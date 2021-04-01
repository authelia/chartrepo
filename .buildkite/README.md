# Buildkite

This repository uses [Buildkite](https://buildkite.com) for CI/CD. The flow for this pipeline works as follows:

1. Buildkite Cloud executes the command `.buildkite/scripts/pipeline.sh | buildkite-agent pipeline upload`.
    1. The script detects various things about the commit and uses `envsubst` to fill `.buildkite/pipeline.yaml` with
       env vars.
    2. The script outputs the yaml and pipes it to the `buildkite-agent pipeline upload` command.

This process means that a majority of the pipeline is documented by existing in the repository. The only things not
documented in this way are because they contain secret information. These things are configured by
[Buildkite hooks](https://buildkite.com/docs/agent/v3/hooks) documented below (the section name is the file name).

## environment

The environment hook configures the environment using the below snippet. Where `abcdef0123456789` is a valid GitHub
access token that has push access to the `gh-pages` branch of the repository, and access to publish releases for the
repository.

```console
#!/usr/bin/env bash

if [[ $BUILDKITE_LABEL == ":k8s: Publish Chart Index (Chart Releaser)" ]] || [[ $BUILDKITE_LABEL == ":github: Deploy Artifacts (Chart Releaser)" ]]; then
  echo "--- :sparkles: Setting environment variables"

  export CR_TOKEN="abcdef0123456789"
fi
```