# Authelia Chart

**NOTICE:** This chart is currently a beta. Until it reaches version 1.0.0 it may have regular breaking changes. It is
not recommended at this stage for production environments without manual intervention to check the templated manifests
match your desired state.

This chart uses api version 2 which is only supported by helm v3+. This is a ***standalone*** chart intended just to
deploy *Authelia* on its own. Eventually we may publish an `authelia-bundle` chart which includes `redis` and
`postgresql`.

# Getting Started

1. Visit https://charts.authelia.com and follow the instructions to install the chart repo.
2. Configure the chart by setting the various [parameters](#parameters), either in a locally downloaded values.yaml or
   in the next step.
3. Install the chart with `helm install authelia/authelia` and optionally set your values with `--values values.yaml` or
   via `--set [parameter]=[value]`.

## Values Files

- **values.yaml:** production environments with LDAP (auth), PostgreSQL (storage), SMTP (notification), and Redis (
  session).
- **values.local.yaml:** environments with file (auth), SQLite3 (storage), filesystem (notification), and memory (
  session).

It is expected you will configure at least the following sections/values:

- domain (this is essential for the chart to work)
- configMap section (the configMap follows a majority of the configuration options
  in [the documentation](https://www.authelia.com/docs/configuration))
- secret section configures passwords and other secret information, configuring this directly in the configMap is not
  supported

# Parameters

This documents the parameters in the chart values. As the chart values are quite large, we've split it into sections.

## General

|Parameter              |Description                                            |Default           |
|:---------------------:|:-----------------------------------------------------:|:----------------:|
|image.registry         |The container registry to use when pulling the image   |docker.io         |
|image.repository       |The registry repository to use when pulling the image  |authelia/authelia |
|image.tag              |The image tag to pull                                  |(latest supported)|
|image.pullSecrets      |The k8s secret names to use for the pullSecrets        |[]                |
|nameOverride           |To be refactored                                       |nil               |
|appNameOverride        |To be refactored                                       |nil               |
|annotations            |A map of extra annotations to add to all manifests     |{}                |
|labels                 |A map of extra labels to add to all manifests          |{}                |
|rbac.enabled           |Enable creation of a ServiceAccount to bind to the pod |false             |
|rbac.annotations       |Extra annotations to add to the ServiceAccount         |{}                |
|rbac.labels            |Extra labels to add to the ServiceAccount              |{}                |
|rbac.serviceAccountName|The name to use for the ServiceAccount                 |authelia          |
|domain                 |The domain to use                                      |example.com       |
|service.annotations    |Extra annotations to add to the service                |{}                |
|service.labels         |Extra labels to add to the Service                     |{}                |
|service.port           |The exposed port on the ClusterIP Service              |80                |
|service.clusterIP      |The ClusterIP to assign to the Service                 |nil               |

## Ingress

To Document.

## ConfigMap

This section only documents the sections that are specific to the helm chart. The majority of this section of the
values.yaml is based on the *Authelia* configuration. See the
[Authelia documentation](https://www.authelia.com/docs/configuration/) for more information.

|Parameter                                              |Description                                             |Default           |
|:-----------------------------------------------------:|:------------------------------------------------------:|:----------------:|
|configMap.enabled                                      |If true generates the ConfigMap, otherwise it doesn't   |true              |
|configMap.annotations                                  |Extra annotations to add to the ConfigMap               |{}                |
|configMap.labels                                       |Extra labels to add to the ConfigMap                    |{}                |
|configMap.key                                          |The key inside the ConfigMap which contains the config  |configuration.yaml|
|configMap.existingConfigMap                            |Instead of generating a ConfigMap refers to an existing |nil               |
|configMap.duo_api.enabled                              |Enables the Duo integration when generating the config  |false             |
|configMap.authentication_backend.ldap.enabled          |Enables LDAP auth when generating the config            |true              |
|configMap.authentication_backend.file.enabled          |Enables file auth when generating the config            |false             |
|configMap.session.redis.enabled                        |Enables redis session storage when generating the config|true              |
|configMap.session.redis.enabledSecret                  |Forces redis password auth using a secret if true       |false             |
|configMap.session.redis.high_availability.enabled      |Enables redis sentinel when generating the config       |false             |
|configMap.session.redis.high_availability.enabledSecret|Forces sentinel password auth using a secret if true    |false             |
|configMap.storage.local.enabled                        |Enables the SQLite3 storage provider                    |false             |
|configMap.storage.mysql.enabled                        |Enables the MySQL storage provider                      |false             |
|configMap.storage.postgres.enabled                     |Enables the PostgreSQL storage provider                 |true              |
|configMap.notifier.filesystem.enabled                  |Enables the filesystem notification provider            |false             |
|configMap.notifier.smtp.enabled                        |Enables the SMTP notification provider                  |true              |
|configMap.notifier.smtp.enabledSecret                  |Forces smtp password auth using a secret if true        |false             |
|configMap.identity_providers.oidc.enabled              |Enables the OpenID Connect Idp                          |false             |

## Secret

The secret section defines how the secret values are added to Authelia. All values that can be a secret are forced as
secrets with this chart. There are likely ways around this but we do not recommend it. Most secrets are automatically
and randomly generated if the value is not defined, however we recommend manually generating the secret and mapping the
chart to it so sensitive material isn't leaked. Alternatively, use HashiCorp Vault.

The `*` below can be one of any of the following values:

- jwt
- ldap
- storage
- session
- duo
- redis
- redisSentinel
- smtp
- oidcPrivateKey
- oidcHMACSecret

### Standard Secret

|Parameter                     |Description                                            |Default                |
|:----------------------------:|:-----------------------------------------------------:|:---------------------:|
|secret.annotations            |A map of extra annotations to add to the Secret        |{}                     |
|secret.labels                 |A map of extra labels to add to the Secret             |{}                     |
|secret.existingSecret         |The name of the existing Secret instead of generating  |nil                    |
|secret.mountPath              |The path where to mount all of the secrets             |/secrets               |
|secret.*.key                  |The key in the secret where the JWT token is stored    |varies                 |
|secret.*.value                |The value to inject into this secret when generating   |nil                    |
|secret.*.filename             |The filename of this secret within the mountPath       |varies                 |

### HashiCorp Vault

|Parameter                                   |Description                                             |Default                |
|:------------------------------------------:|:------------------------------------------------------:|:---------------------:|
|secret.annotations                          |A map of extra annotations to add to the pod for Vault  |{}                     |
|secret.mountPath                            |The path where to mount all of the secrets              |/secrets               |
|secret.vaultInjector.enabled                |Enables HashiCorp Vault Injector annotations            |false                  |
|secret.vaultInjector.role                   |Vault role to use                                       |authelia               |
|secret.vaultInjector.agent.status           |Value to inject to prevent further mutations            |update                 |
|secret.vaultInjector.agent.configMap        |Name of configMap where the agent config can be found   |nil                    |
|secret.vaultInjector.agent.image            |Customizes the image to use for the agent               |nil                    |
|secret.vaultInjector.agent.initFirst        |Configures the agent to init first if true              |false                  |
|secret.vaultInjector.agent.command          |Configures the default command to run on inject         |sh -c 'kill HUP $(pidof authelia)'|
|secret.vaultInjector.agent.runAsSameUser    |Runs the agent as the same user as the pod              |true                   |
|secret.vaultInjector.agent.templateValue    |Configures the default secret rendering template        |nil                    |
|secret.vaultInjector.secrets.*.path         |Configures the vault path to obtain the secret from     |varies                 |
|secret.vaultInjector.secrets.*.templateValue|Configures the secret rendering template for this secret|nil                    |
|secret.vaultInjector.secrets.*.command      |Configures the secret post-render cmd for this secret   |nil                    |

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