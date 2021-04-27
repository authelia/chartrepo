# Buildkite

This repository uses [Buildkite] for CI/CD. The flow for this pipeline works as follows:

1. Buildkite Cloud executes the command `.buildkite/scripts/pipeline.sh | buildkite-agent pipeline upload`.
    1. The script detects various things about the commit and uses `envsubst` to fill `.buildkite/pipeline.yaml` with
       env vars.
    2. The script outputs the yaml and pipes it to the `buildkite-agent pipeline upload` command.

This process means that a majority of the pipeline is documented by existing in the repository. The only things not
documented in this way are because they contain secret information. These things are configured by [hooks] documented
below.

## Hooks

There are two locations [hooks] can be located. Either on the individual agent home directories or in the repository.
The [hooks] stored in the repository are all located in the
[.buildkite/hooks](https://github.com/authelia/chartrepo/tree/master/.buildkite) directory. All [hooks] located locally
on individual agents are documented below.

### environment

The environment hook configures the environment using the below snippet. Where `abcdef0123456789` is a valid GitHub
access token that has push access to the `gh-pages` branch of the repository, and access to publish releases for the
repository. This file needs to be mounted in the ~/hooks directory (hooks directory inside the home of the user running
the agent).

```console
#!/usr/bin/env bash
set -eu

if [[ "${BUILDKITE_PIPELINE_NAME}" == "Charts" ]]; then
  if [[ "${BUILDKITE_STEP_KEY}" == "index" ]] || [[ "${BUILDKITE_STEP_KEY}" == "upload" ]]; then
    echo "--- :sparkles: Setting environment variables"

    export CR_TOKEN="abcdef0123456789"
  fi
fi
```

## Additional Information

The following table lists files used in CI/CD and their purposes.

|File                          |Purpose                                                |
|:----------------------------:|:-----------------------------------------------------:|
|.yamllint.yaml                |Configuration for linting the yaml aspects of charts   |
|.buildkite/cr.yaml            |Configuration for Chart Releaser                       |
|.buildkite/ct.yaml            |Configuration for Chart Testing (linting tasks)        |
|.buildkite/ct.version.yaml    |Configuration for Chart Testing (version check task)   |
|.buildkite/chart_schema.yaml  |Configuration for checking the Chart.yaml schema       |
|.buildkite/pipeline.yaml      |The Buildkite pipeline template which is envsubst'd    |
|.buildkite/scripts/pipeline.sh|The script to derive env vars to envsubst pipeline.yaml|
|.buildkite/hooks/post-checkout|This hook does tasks directly after the checkout       |
|.buildkite/hooks/pre-command  |This hook does tasks directly before the actual step   |

[hooks]: https://buildkite.com/docs/agent/v3/hooks

[Buildkite]: https://buildkite.com