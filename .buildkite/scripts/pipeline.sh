#!/usr/bin/env bash

if [[ "${BUILDKITE_BRANCH}" == "master" ]]; then
  export CHART_CHANGES=$(git diff --name-only HEAD~1 | sed -rn '/^charts\/[a-zA-Z0-9-]+\/(templates\/.*|crds\/.*|Chart.yaml|values.yaml|values.schema.json|LICENSE|README.md)/{q1}' && echo false || echo true)
else
  export CHART_CHANGES=$(git diff --name-only `git merge-base --fork-point origin/master` | sed -rn '/^charts\/[a-zA-Z0-9-]+\/(templates\/.*|crds\/.*|Chart.yaml|values.yaml|values.schema.json|LICENSE|README.md)/{q1}' && echo false || echo true)
fi

envsubst < .buildkite/pipeline.yaml