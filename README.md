# Authelia Helm Chart Repository

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

This repository is for hosting Authelia specific helm charts. Currently we only host a single chart which is still in
development.

## Getting Started

Make sure [Helm](https://helm.sh) is [installed](https://helm.sh/docs/intro/install/).

Once you've installed [Helm](https://helm.sh):

```console
helm repo add authelia https://authelia.github.io/chartrepo
```

You can then the following command to see the charts in our repository:

```console
helm search repo authelia
```