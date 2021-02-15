# Authelia Chart

**NOTICE:** This chart is currently a beta. Until it reaches version 1.0.0 it may have regular breaking changes. It is
not recommended at this stage for production environments without manual intervention to check the templated manifests
match your desired state.

# Getting Started

Visit https://charts.authelia.com and follow the instructions to install the chart repo.

A more in depth guide is coming. Some key points below.

The chart values.yaml is configured by default for production environments. It expects you will configure the following
sections:

- domain (this is essential for the chart to work)
- configMap (the configMap follows a majority of the configuration options
  in [the documentation](https://www.authelia.com/docs/configuration))
- secret section to setup passwords and other secret information, configuring this directly is not supported

# TODO

- CI:
  - [ ] helm lint
  - [ ] renovate
  - [ ] yamllint config
  - [ ] [chart-testing](https://github.com/helm/chart-testing)
  - [ ] [chart-releaser](https://github.com/helm/chart-releaser)
  - [ ] Ensure no changes to the following files can be merged without a version bump to Chart.yaml:
    - ./templates/*
    - ./values.yaml
    - ./values.*.yaml
    - ./Chart.lock
    - ./README.md
    - ./LICENSE
  - [ ] Integration Testing
- Chart Kinds:
  - [x] Deployment
  - [x] Ingress
  - TraefikCRD:
    - [x] IngressRoute
    - [x] Middleware
- Validation:
  - [ ] Add validation checks for defined providers (allow one)
  - [ ] Add Statefulness validation
  - [ ] Setup volumeClaimTemplates for stateful installs
- Ingress:
  - [ ] Test ingress-nginx
  - [ ] Test traefikCRD tls
- Values Schema:
  - Future Notes?
  - [x] https://github.com/CesiumGS/wetzel
  - [x] https://github.com/karuppiah7890/helm-schema-gen
- Misc
  - [x] updateStrategy
  - [ ] docs
  - [ ] investigate/implement TLS, including on the probe schemes (have to check if we can inject a ca)
  - [x] trusted certs
  - [ ] templates/NOTES.txt
- Low Priority (not needed for beta/stable)
  - [x] file auth provider (secret - ldap is recommended for k8s)
  - [x] local db (pv/pvc - proper db recommended for k8s)
  - [x] podSecurityPolicy
  - [x] podDisruptionBudget