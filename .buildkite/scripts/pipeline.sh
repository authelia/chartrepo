#!/usr/bin/env bash

if [[ "${BUILDKITE_BRANCH}" == "master" ]]; then
  CHART_CHANGES=$(git diff --name-only HEAD~1 | sed -rn '/^charts\/[a-zA-Z0-9-]+\/(templates\/.*|crds\/.*|Chart.yaml|values.yaml|values.schema.json|LICENSE|README.md)/{q1}' && echo false || echo true)
  if [[ "${CHART_CHANGES}" == "true" ]]; then
    export CR_BYPASS=false
  else
    export CR_BYPASS=true
  fi
else
  CHART_CHANGES=$(git diff --name-only `git merge-base --fork-point origin/master` | sed -rn '/^charts\/[a-zA-Z0-9-]+\/(templates\/.*|crds\/.*|Chart.yaml|values.yaml|values.schema.json|LICENSE|README.md)/{q1}' && echo false || echo true)
  export CR_BYPASS=true
fi

if [[ "${CHART_CHANGES}" == "true" ]]; then
  export CT_BYPASS=false
else
  export CT_BYPASS=true
fi

envsubst < .buildkite/pipeline.yaml