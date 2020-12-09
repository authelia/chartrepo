# Authelia Experimental Chart

Experimental chart, many bugs will exist and many intended features are missing.

# TODO

* CI:
    * helm lint
    * helm chart-releaser
    * Integration Testing
* Chart Kinds:
    * Deployment (complete misc tasks in DaemonSet first and use as a baseline or autoconvert)
    * Ingress
    * TraefikCRD:
        * IngressRoute
        * Middleware
* Misc
    * updateStrategy
    * podSecurityPolicy
    * podDisruptionBudget
    * values.prod.yaml?
    * values.schema.json
    * docs
* Low Priority (not needed for beta/stable)
    * file auth provider (secret - ldap is recommended for k8s)
    * local db (pv/pvc - proper db recommended for k8s)