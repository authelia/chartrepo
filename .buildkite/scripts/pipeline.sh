#!/usr/bin/env bash

if [[ $BUILDKITE_BRANCH == "master" ]]; then
  CR_BYPASS=$(git diff --name-only HEAD~1 | sed -rn '/^charts\/[a-zA-Z0-9-]+\/(templates\/.*|crds\/.*|Chart.yaml|values.yaml|values.schema.json|LICENSE|README.md)/!{q1}' && echo false || echo true)
else
  CR_BYPASS=$(git diff --name-only `git merge-base --fork-point origin/master` | sed -rn '/^charts\/[a-zA-Z0-9-]+\/(templates\/.*|crds\/.*|Chart.yaml|values.yaml|values.schema.json|LICENSE|README.md)/!{q1}' && echo false || echo true)
fi

cat << EOF
env:
  CR_BYPASS: ${CR_BYPASS}

steps:
  - label: ":helm: Linting (Chart Testing)"
    command: "ct --config .buildkite/ct.yaml lint"
    agents:
      charts: "true"
    if: build.branch != "gh-pages"

  - label: ":buildkite: Setup Deployment"
    command: "mkdir .cr-release-packages .cr-index"
    agents:
      charts: "true"
    if: build.branch == "master" && build.env("CR_BYPASS") != "true"

  - label: ":package: Package Chart (Chart Releaser)"
    command: "ct --config .buildkite/ct.yaml list-changed | xargs -n1 cr --config .buildkite/cr.yaml package"
    agents:
      charts: "true"
    if: build.branch == "master" && build.env("CR_BYPASS") != "true"

  - label: ":github: Deploy Artifacts (Chart Releaser)"
    command: "cr --config .buildkite/cr.yaml upload"
    agents:
      charts: "true"
    if: build.branch == "master" && build.env("CR_BYPASS") != "true"

  - label: ":k8s: Publish Chart Index (Chart Releaser)"
    command: "cr --config .buildkite/cr.yaml index --push"
    agents:
      charts: "true"
    if: build.branch == "master" && build.env("CR_BYPASS") != "true"
EOF