# Authelia Chart

**NOTICE:** This chart is currently a beta. Until it reaches version 1.0.0 it may have regular breaking changes. It is
not recommended at this stage for production environments without manual intervention to check the templated manifests
match your desired state.

This chart uses api version 2 which is only supported by helm v3+. This chart includes optional Bitnami subcharts to deploy `redis`, `postgresql`, and/or `mariadb`.

# Breaking Changes

Breaking changes with this chart should be expected during the v0.x.x versions at any time however we aim to keep the
breaking changes within minor releases i.e. from v0.1.0 to v0.2.0. The following versions have notable breaking changes
which users should be aware of:

- [v0.9.0](https://github.com/authelia/chartrepo/blob/master/charts/authelia/BREAKING.md#090)
- [v0.5.0](https://github.com/authelia/chartrepo/blob/master/charts/authelia/BREAKING.md#050)

# Getting Started

1. Visit https://charts.authelia.com and follow the instructions to install the chart repo.
2. Configure the chart by setting the various [parameters](#parameters), either in a locally downloaded values.yaml or
   in the next step.
3. Install the chart with `helm install authelia authelia/authelia` and optionally set your values with `--values values.yaml` or
   via `--set [parameter]=[value]`.

## Values Files

- **values.yaml:** basic template with no specific feature states enabled.
- **values.production.yaml:** production environments with LDAP (auth), PostgreSQL (storage), SMTP (notification), and 
  Redis (session).
- **values.local.yaml:** environments with file (auth), SQLite3 (storage), filesystem (notification), and memory (
  session).

## Expected Minimum Configuration

It is expected you will configure at least the following sections/values:

- The configMap section (the configMap follows a majority of the configuration options
  in [the documentation](https://www.authelia.com/configuration))
  - The `configMap.session.cookies` section contains the domain configuration for the Authelia portal and session
    cookies:
    - The full Authelia URL will be in the format of `https://[<subdomain>.]<domain>[/<subpath>]` (part within the square braces is
      omitted if not configured) i.e. `domain` of `example.com` and `subdomain` empty yields `https://example.com` and
      `subdomain` of `auth` yields `https://auth.example.com`. The `subpath` is also optionally included.
    - The `domain` option is required.
    - The `subdomain` option is generally required.
    - The `path` option is generally **_NOT_** required or recommended. Every domain that has this option configured
      MUST have the same value i.e. you can have one blank and one configured but all those that are configured must be
      the same, and in addition if configured at all the `configMap.server.path` option must have the same value.

  - The following sections require one of the sub-options enabled:
    - The `configMap.storage` section:
      - `postgres`
      - `mysql`
      - `local` (stateful)
    - The `configMap.notifier` section:
      - `smtp`
      - `filesystem` (stateful)
    - The `configMap.authentication_backend` section:
      - `ldap`
      - `file` (stateful)

# Parameters

This documents the parameters in the chart values. As the chart values are quite large, we've split it into sections.

## General

|        Parameter        |                      Description                       |      Default       |
|:-----------------------:|:------------------------------------------------------:|:------------------:|
|     image.registry      |  The container registry to use when pulling the image  |     docker.io      |
|    image.repository     | The registry repository to use when pulling the image  | authelia/authelia  |
|        image.tag        |                 The image tag to pull                  | (latest supported) |
|    image.pullSecrets    |    The k8s secret names to use for the pullSecrets     |         []         |
|      nameOverride       |                    To be refactored                    |        nil         |
|     appNameOverride     |                    To be refactored                    |        nil         |
|       annotations       |   A map of extra annotations to add to all manifests   |         {}         |
|         labels          |     A map of extra labels to add to all manifests      |         {}         |
|      rbac.enabled       | Enable creation of a ServiceAccount to bind to the pod |       false        |
|    rbac.annotations     |     Extra annotations to add to the ServiceAccount     |         {}         |
|       rbac.labels       |       Extra labels to add to the ServiceAccount        |         {}         |
| rbac.serviceAccountName |         The name to use for the ServiceAccount         |      authelia      |
|   service.annotations   |        Extra annotations to add to the service         |         {}         |
|     service.labels      |           Extra labels to add to the Service           |         {}         |
|      service.port       |       The exposed port on the ClusterIP Service        |         80         |
|    service.clusterIP    |         The ClusterIP to assign to the Service         |        nil         |
|   kubeVersionOverride   |   Allows overriding the detected Kubernetes Version    |        nil         |
|  kubeDNSDomainOverride  |  Allows overriding the default Kubernetes DNS Domain   |        nil         |

## Pod

|                 Parameter                 |                          Description                           |    Default    |
|:-----------------------------------------:|:--------------------------------------------------------------:|:-------------:|
|                 pod.kind                  | Configures the kind of pod: StatefulSet, Deployment, DaemonSet |   DaemonSet   |
|              pod.annotations              |            Adds annotations specifically to the pod            |      {}       |
|                pod.labels                 |              Adds labels specifically to the pod               |      {}       |
|            pod.initContainers             |    Adds additional init containers specifically to the pod     |      []       |
|               pod.replicas                |     Configures the replicas for Deployment's/statefulSet's     |       1       |
|         pod.revisionHistoryLimit          |              Configures the revisionHistoryLimit               |       1       |
|             pod.strategy.type             |        Configures the pods strategy/updateStrategy type        | RollingUpdate |
|    pod.strategy.rollingUpdate.maxSurge    |          Configures the pods rolling update max surge          |      25%      |
| pod.strategy.rollingUpdate.maxUnavailable |       Configures the pods rolling update max unavailable       |      25%      |
|   pod.strategy.rollingUpdate.partition    |          Configures the pods rolling update partition          |       1       |
|       pod.securityContext.container       |        Configures the main container's security context        |      {}       |
|          pod.securityContext.pod          |             Configures the pod's security context              |      {}       |
|              pod.tolerations              |                Configures the pods tolerations                 |      []       |
|        pod.selectors.nodeSelector         |    Configures the pod to select nodes based on node labels     |      {}       |
|    pod.selectors.affinity.nodeAffinity    |       Configures the pod to select nodes based affinity        |      {}       |
|    pod.selectors.affinity.podAffinity     |   Configures the pod to select nodes based pods on the node    |      {}       |
|  pod.selectors.affinity.podAntiAffinity   |   Configures the pod to select nodes based pods on the node    |      {}       |
|                  pod.env                  |            Configures extra env to add to the node             |      []       |
|         pod.resources.limits.cpu          |             Configures the resource limit for CPU              |      nil      |
|        pod.resources.limits.memory        |            Configures the resource limit for memory            |      nil      |
|        pod.resources.requests.cpu         |            Configures the resource request for CPU             |      nil      |
|       pod.resources.requests.memory       |           Configures the resource request for memory           |      nil      |

## Ingress

In addition to the below configuration parameters it should be noted that the generated ingress manifests use the values
from configMap.session.cookies to determine how many ingress manifests to generate and how they should be configured.
The configMap.session.cookies is a list of objects which have some key properties for this purpose, the `domain` is the
suffix of the host, and if configured the `subdomain` is the prefix of the host (separated by a period). 

|                   Parameter                   |                                        Description                                         |   Default    |
|:---------------------------------------------:|:------------------------------------------------------------------------------------------:|:------------:|
|                ingress.enabled                |                    Enable the ingress for any type of proxy integration                    |    false     |
|              ingress.annotations              |                        Adds annotations specifically to the ingress                        |      {}      |
|                ingress.labels                 |                          Adds labels specifically to the ingress                           |      {}      |
|                  tls.enabled                  |                            Enable the tls cert for the ingress                             |     true     |
|                  tls.secret                   |                       The tls cert that will be used in the ingress                        | authelia-tls |
|          ingress.traefikCRD.enabled           |                              Enable the traefik for the proxy                              |    false     |
|    ingress.traefikCRD.disableIngressRoute     |                     The ingress route can be disabled using the value                      |    false     |
|        ingress.traefikCRD.entryPoints         |                      Entry Points configuration in the ingress route                       |      []      |
|           ingress.traefikCRD.sticky           |                       enable the sticky cookie in the ingress route                        |    false     |
|     ingress.traefikCRD.chains.auth.before     | List of Middlewares to apply before the forwardAuth Middleware in the authentication chain |      []      |
|     ingress.traefikCRD.chains.auth.after      | List of Middlewares to apply after the forwardAuth Middleware in the authentication chain  |      []      |
| ingress.traefikCRD.chains.ingressRoute.before |        List of Middlewares to apply before the middleware in the IngressRoute chain        |      []      |
| ingress.traefikCRD.chains.ingressRoute.after  |        List of Middlewares to apply after the middleware in the IngressRoute chain         |      []      |

## ConfigMap

This section only documents the sections that are specific to the helm chart. The majority of this section of the
values.yaml is based on the *Authelia* configuration. See the
[Authelia documentation](https://www.authelia.com/configuration) for more information.

|                        Parameter                        |                       Description                        |      Default       |
|:-------------------------------------------------------:|:--------------------------------------------------------:|:------------------:|
|                    configMap.enabled                    |  If true generates the ConfigMap, otherwise it doesn't   |        true        |
|                  configMap.annotations                  |        Extra annotations to add to the ConfigMap         |         {}         |
|                    configMap.labels                     |           Extra labels to add to the ConfigMap           |         {}         |
|                      configMap.key                      |  The key inside the ConfigMap which contains the config  | configuration.yaml |
|               configMap.existingConfigMap               | Instead of generating a ConfigMap refers to an existing  |        nil         |
|                configMap.duo_api.enabled                |  Enables the Duo integration when generating the config  |       false        |
|      configMap.authentication_backend.ldap.enabled      |       Enables LDAP auth when generating the config       |        true        |
|      configMap.authentication_backend.file.enabled      |       Enables file auth when generating the config       |       false        |
|             configMap.session.redis.enabled             | Enables redis session storage when generating the config |        true        |
|             configMap.session.redis.deploy              |                 Deploy a redis instance                  |       false        |
|          configMap.session.redis.enabledSecret          |    Forces redis password auth using a secret if true     |       false        |
|    configMap.session.redis.high_availability.enabled    |    Enables redis sentinel when generating the config     |       false        |
| configMap.session.redis.high_availability.enabledSecret |   Forces sentinel password auth using a secret if true   |       false        |
|             configMap.storage.local.enabled             |           Enables the SQLite3 storage provider           |       false        |
|             configMap.storage.mysql.enabled             |            Enables the MySQL storage provider            |       false        |
|             configMap.storage.mysql.deploy              |                Deploy a MariaDB instance                 |       false        |
|           configMap.storage.postgres.enabled            |         Enables the PostgreSQL storage provider          |        true        |
|           configMap.storage.postgres.deploy             |               Deploy a PostgreSQL instance               |       false        |
|          configMap.notifier.filesystem.enabled          |       Enables the filesystem notification provider       |       false        |
|             configMap.notifier.smtp.enabled             |          Enables the SMTP notification provider          |        true        |
|          configMap.notifier.smtp.enabledSecret          |     Forces smtp password auth using a secret if true     |       false        |
|        configMap.identity_providers.oidc.enabled        |              Enables the OpenID Connect Idp              |       false        |

If any of `configMap.session.redis.deploy`, `configMap.storage.mysql.deploy` or `configMap.storage.postgres.deploy` are enabled, the corresponding top-level `redis`, `mariadb` or `postgresql` sections must be configured.
For more information, refer to the [Bitnami Redis Chart](https://github.com/bitnami/charts/tree/master/bitnami/redis), [Bitnami MariaDB Chart](https://github.com/bitnami/charts/tree/master/bitnami/mariadb), and [Bitnami PostgreSQL Chart](https://github.com/bitnami/charts/tree/master/bitnami/postgresql) documentation.
## Secret

The secret section defines how the secret values are added to Authelia. All values that can be a secret are forced as
secrets with this chart. There are likely ways around this but we do not recommend it. Most secrets are automatically
and randomly generated if the value is not defined, however we recommend manually generating the secret and mapping the
chart to it so sensitive material isn't leaked.

The `*` below can be one of any of the following values:

- jwt
- ldap
- storage
- storageEncryptionKey
- session
- duo
- redis
- redisSentinel
- smtp
- oidcPrivateKey
- oidcHMACSecret

|       Parameter       |                      Description                       | Default  |
|:---------------------:|:------------------------------------------------------:|:--------:|
|  secret.annotations   |    A map of extra annotations to add to the Secret     |    {}    |
|     secret.labels     |       A map of extra labels to add to the Secret       |    {}    |
| secret.existingSecret | The name of the existing Secret instead of generating  |   nil    |
|   secret.mountPath    |       The path where to mount all of the secrets       | /secrets |
|     secret.*.key      | The key in the secret where the secret value is stored |  varies  |
|    secret.*.value     |  The value to inject into this secret when generating  |   nil    |
|   secret.*.filename   |    The filename of this secret within the mountPath    |  varies  |

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
