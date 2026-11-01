---
name: dbt-model-governance
description: Design or audit dbt model graphs for clear grains and responsibilities, explicit projections, project boundaries, and governance checks. Use for dbt repository structure, model quality reviews, or dbt_project_evaluator integration.
---

# dbt model governance

Read the repository's instructions, layout documentation, dbt version, package declarations, and paved tasks before changing models. Treat folder names, model-count targets, and naming patterns as project conventions; do not impose one project's layout on another.

For each model being added or reviewed, state its output grain, the source or parent relations it owns, the transformation or reporting question it answers, and its consumers. Keep one coherent output responsibility per model. Several CTEs or joins can serve one responsibility; one-line pass-through models can be useful when they pin a cross-project contract. Check whether each staging or intermediate model reaches a downstream model; tests alone do not make a model useful. Question models that duplicate a parent's output or exist only to increase a folder count.

Use explicit projected columns in model SQL, including cross-project import models. Check units, currencies, time zones, and null behavior at public boundaries. When changing a public model, inspect its contract, version pins, downstream imports, and tests before editing it. Keep staging tied to a source system, intermediate models tied to a transformation or use case, and marts tied to a reporting use case when that is the repository's chosen organization.

Use [dbt Labs' project evaluator](https://github.com/dbt-labs/dbt-project-evaluator) when governance needs a graph-level check. Verify package and dbt version compatibility first: evaluator 1.4.1 supports dbt Core 1.12, while evaluator 2.x requires dbt 2.x. Run the evaluator and inspect the rows behind each flagged rule. It can identify contract, documentation, testing, lineage, and graph-shape issues; it cannot prove that a model has one business responsibility. Treat intentional fanout or generated calendar roots as explicit, documented choices. Do not silence a rule or raise its threshold just to make CI green.

Verify changes with the repository's tasks. Check naming and SQL lint, unit and data tests, full builds on supported adapters, and state-based CI when upstream contracts change. Report exact failures, configured warnings, and rules left advisory. Keep a clear distinction between package findings, code behavior, and local conventions.
