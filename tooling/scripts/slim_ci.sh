#!/usr/bin/env bash
# Slim CI on DuckDB: build only what a change touches, deferring everything
# else to a baseline built from the base ref.
#
#   tooling/scripts/slim_ci.sh <base-ref>        e.g. origin/main
#
# 1. Check out <base-ref> in a worktree and build every project there with the
#    prod_duckdb target (unprefixed schemas): this is the "production" state.
# 2. platform:  dbt build --select state:modified+ --defer --state <base manifest>
#    Unselected parents resolve to the baseline relations instead of being rebuilt.
# 3. consumers: their own changes, plus everything downstream of the platform
#    models this change touched (`platform.<model>+` selects through the nodes
#    dbt-loom injects). Plain state:modified+ would rebuild every consumer
#    model: injected nodes point at dev schemas here and at prod schemas in
#    the baseline, so state:modified.relation flags all of them.
# A project that does not exist at <base-ref> is built in full.
# Both sides read the same raw data (data/raw.duckdb) and dbt/profiles.yml.
# The PR side parses from scratch: a stale target/partial_parse.msgpack can
# carry old raw_code and make unchanged models look modified.
set -euo pipefail

base_ref=${1:?usage: slim_ci.sh <base-ref>}
repo=$(git rev-parse --show-toplevel)
projects=(platform finance growth)
base_dir=$(mktemp -d)/base
trap 'git -C "$repo" worktree remove --force "$base_dir" >/dev/null 2>&1 || true' EXIT

git -C "$repo" worktree add --detach --quiet "$base_dir" "$base_ref"
echo "==> baseline: $(git -C "$base_dir" log --oneline -1)"

export REPO_ROOT="$repo" DBT_PROFILES_DIR="$repo/dbt"
base_projects="$base_dir/dbt/projects"
[ -d "$base_projects" ] || base_projects="$base_dir/projects"
for project in "${projects[@]}"; do
  [ -d "$base_projects/$project" ] || continue
  echo "==> baseline build: $project"
  (cd "$base_projects/$project" && uv run --project "$repo" dbt deps --quiet \
    && DBT_TARGET=prod_duckdb uv run --project "$repo" dbt build --exclude-resource-type unit_test --quiet)
done

own_changes="state:modified.body+ state:modified.configs+ state:modified.contract+ state:modified.macros+"
platform_changes=""
for project in "${projects[@]}"; do
  state="$base_projects/$project/target"
  cd "$repo/dbt/projects/$project"
  uv run dbt deps --quiet
  if [ -f "$state/manifest.json" ]; then
    if [ "$project" = platform ]; then
      select="state:modified+"; exclude=""
    else
      # The injected platform nodes themselves are selected by `platform.<model>+`
      # but are not this project's to build.
      select="$own_changes $platform_changes"; exclude="package:platform"
    fi
    echo "==> slim build: $project (vs $base_ref): $select"
    DBT_TARGET=duckdb uv run dbt build --no-partial-parse --select $select \
      --exclude package:dbt_project_evaluator $exclude \
      --defer --state "$state" --exclude-resource-type unit_test
    if [ "$project" = platform ]; then
      platform_changes=$(DBT_TARGET=duckdb uv run dbt ls --quiet --select state:modified --state "$state" \
        --exclude package:dbt_project_evaluator \
        --resource-type model --output json --output-keys name version \
        | uv run python "$repo/tooling/scripts/upstream_selectors.py" platform)
      echo "    platform models changed: ${platform_changes:-none}"
    fi
  else
    echo "==> full build: $project (not present at $base_ref)"
    DBT_TARGET=duckdb uv run dbt build --no-partial-parse \
      --exclude package:dbt_project_evaluator --exclude-resource-type unit_test
  fi
done
