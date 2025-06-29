#!/usr/bin/env bash

if [[ "${BUILDKITE_BRANCH}" == "master" ]]; then
  exoirt CHART_CHANGES=$(git diff --name-only HEAD~1 -- "charts/*/*.md" "charts/*/templates/*" "charts/*/files/*" "charts/*/Chart.yaml" "charts/*/values.yaml" "charts/*/values.*.yaml" "charts/*/values.schema.json" "charts/*/LICENSE" "charts/*/crds/*" "charts/*/Chart.lock" | sed -rn '{q1}' && echo false || echo true)
else
  exoirt CHART_CHANGES=$(git diff --name-only `git merge-base --fork-point origin/master` -- "charts/*/*.md" "charts/*/templates/*" "charts/*/files/*" "charts/*/Chart.yaml" "charts/*/values.yaml" "charts/*/values.*.yaml" "charts/*/values.schema.json" "charts/*/LICENSE" "charts/*/crds/*" "charts/*/Chart.lock" | sed -rn '{q1}' && echo false || echo true)
fi

envsubst < .buildkite/pipeline.yaml