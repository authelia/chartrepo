# Authelia Chart

**NOTICE:** This chart is currently a beta. Until it reaches version 1.0.0 it may have regular breaking changes. It is
not recommended at this stage for production environments without manual intervention to check the templated manifests
match your desired state.

# TODO

- CI:
  - [ ] helm lint
  - [ ] renovate
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