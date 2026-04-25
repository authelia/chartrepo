# Contributing

Thank you for your interest in contributing to the Authelia chart repository! This document describes the workflow and
conventions you should follow when proposing changes.

If you have not already, please also read the [Authelia Code of Conduct](https://www.authelia.com/policies/code-of-conduct/)
and the [Authelia Contributing Guide](https://www.authelia.com/contributing/prologue/introduction/).

## Getting Started

1. Fork the repository and clone your fork locally.
2. Create a feature branch off `master` for your changes.
3. Install the tooling required to regenerate generated files (see [Tooling](#tooling) below).
4. Make your changes following the [Chart Modification Workflow](#chart-modification-workflow).
5. Open a pull request against `master`.

## Tooling

Most generated files are produced by `helm-docs` and `helm-schema`. Both can be installed via the `Makefile`:

```bash
make install
```

This installs:

- [`helm-docs`](https://github.com/norwoodj/helm-docs); generates `README.md` from `README.md.gotmpl` and `values.yaml`.
- [`helm-schema`](https://github.com/dadav/helm-schema); generates `values.schema.json` from `values.yaml` annotations.

You will also need a recent version of [Go](https://go.dev/) on your `PATH` for the installer to work.

## Chart Modification Workflow

When modifying a chart please follow these rules carefully; CI will fail if any of them are missed.

### 1. Always bump the chart version

For any chart you modify you **must** update `charts/<chart>/Chart.yaml`:

- Increment the `version` field (these charts use `0.major.minor` while pre-1.0; see the development status note in the
  root [README](README.md) for details).
- Update the `artifacthub.io/changes` annotation to describe the change. Use one entry per logical change with an
  appropriate `kind` (one of: `added`, `changed`, `deprecated`, `removed`, `fixed`, `security`). For example:

  ```yaml
  annotations:
    artifacthub.io/changes: |
      - kind: fixed
        description: Missing type definition for several values.
  ```

If your PR makes changes to multiple charts, repeat this for each chart you touch.

### 2. Never edit `README.md` directly

The chart-level `README.md` is **generated**. Any manual edits will be overwritten.

- For prose / structural changes, edit `charts/<chart>/README.md.gotmpl`.
- For changes to the values table, edit the `# --` doc comments in `charts/<chart>/values.yaml`.
- Then regenerate (see [Always run `make docs schema`](#4-always-run-make-docs-schema-before-committing) below).

### 3. Never edit `values.schema.json` directly

The chart-level `values.schema.json` is **generated** from `# @schema` annotations in `values.yaml`. Manual edits will
be overwritten.

- To change types, defaults, enums, required fields, or descriptions, edit the appropriate block in
  `charts/<chart>/values.yaml`.
- Refer to the [helm-schema documentation](https://github.com/dadav/helm-schema) for the full annotation syntax.

### 4. Always run `make docs schema` before committing

Before you commit, regenerate the documentation and schema so they stay in sync with `values.yaml`:

```bash
make docs schema
```

This runs `helm-docs` and `helm-schema` against every chart and updates `README.md` and `values.schema.json` in place.
Commit the regenerated files alongside your changes.

CI enforces this with `make lint-docs` and `make lint-schema`, which both fail if the generated output differs from
what is committed. You can run the full lint suite locally with:

```bash
make lint
```

### 5. Use Conventional Commits

Commit messages and pull request titles must follow the [Conventional Commits](https://www.conventionalcommits.org/)
specification. The most common types used in this repository are:

- `feat`; a new feature.
- `fix`; a bug fix.
- `docs`; documentation-only changes.
- `refactor`; a code change that neither fixes a bug nor adds a feature.
- `ci`; changes to CI configuration or tooling.

When the change targets a specific chart, include the chart name as the scope, for example:

```text
feat(authelia): add support for OpenID Connect device authorization
fix(authelia): correct cookie remember_me example value
```

Breaking changes must be indicated with a `!` after the type/scope or with a `BREAKING CHANGE:` footer, and should
also be documented in the chart's `BREAKING.md` where applicable.

## Pull Request Checklist

Before opening a PR, please confirm:

- [ ] `Chart.yaml` `version` has been bumped for every chart you modified.
- [ ] `Chart.yaml` `artifacthub.io/changes` annotation describes your change.
- [ ] `README.md` was **not** edited directly; `README.md.gotmpl` and/or `values.yaml` were edited instead.
- [ ] `values.schema.json` was **not** edited directly; `values.yaml` `# @schema` annotations were edited instead.
- [ ] `make docs schema` has been run and the regenerated files are committed.
- [ ] `make lint` passes locally.
- [ ] Commit messages and PR title follow Conventional Commits.

## Reporting Issues

If you have found a bug or want to request a feature, please open an issue at
<https://github.com/authelia/chartrepo/issues> with as much context as possible (chart version, Kubernetes version,
relevant values, and the rendered output where applicable).