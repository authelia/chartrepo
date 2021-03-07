#!/usr/bin/env bash

if [[ $BUILDKITE_BRANCH == "master" ]]; then
  export CR_BYPASS=$(git diff --name-only HEAD~1 | sed -rn '/^charts\/[a-zA-Z0-9-]+\/(templates\/.*|crds\/.*|Chart.yaml|values.yaml|values.schema.json|LICENSE|README.md)/{q1}' && echo true || echo false)
else
  export CR_BYPASS=true
fi

envsubst < .buildkite/pipeline.yaml