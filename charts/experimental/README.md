# Authelia Experimental Chart

Experimental chart, many bugs will exist and many intended features are missing.

# TODO

- CI:
    - [ ] helm lint
    - [ ] helm chart-releaser
    - [ ] Integration Testing
- Chart Kinds:
    - [x] Deployment
    - [x] Ingress
    - TraefikCRD:
        - [x] IngressRoute
        - [x] Middleware
- Values Schema:
    - [ ] https://github.com/CesiumGS/wetzel
    - [ ] https://github.com/karuppiah7890/helm-schema-gen
- Misc
    - [x] updateStrategy
    - [ ] values.prod.yaml?
    - [ ] docs
    - [ ] investigate/implement TLS, including on the probe schemes (have to check if we can inject a ca)
    - [ ] trusted certs
    - [ ] templates/NOTES.txt
- Low Priority (not needed for beta/stable)
    - [ ] file auth provider (secret - ldap is recommended for k8s)
    - [ ] local db (pv/pvc - proper db recommended for k8s)
    - [ ] podSecurityPolicy
    - [ ] podDisruptionBudget