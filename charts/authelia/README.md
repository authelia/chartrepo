# Authelia Chart

**NOTICE:** This chart is currently a beta. Until it reaches version 1.0.0 it may have regular breaking changes. It is
not recommended at this stage for production environments without manual intervention to check the templated manifests
match your desired state.

This chart uses api version 2 which is only supported by helm v3+. This is a ***standalone*** chart intended just to
deploy *Authelia* on its own. Eventually we may publish an `authelia-bundle` chart which includes `redis` and
`postgresql`.

# Breaking Changes

During the beta we will generally not be documenting breaking chart changes but there are exceptions and they are noted
below.

## 0.9.0

While we have aimed to keep documented backwards compatability for previous versions of Authelia deployed with the chart
we have to draw a line with this release. Due to the way the chart was designed and the introduction of mutli-cookie
domains and the new authz endpoints there is just too much to do. We're therefore cutting off support for prior releases
with this release.

It's difficult for users when we make breaking changes and this one is unfortunately quite substantial. We're hoping
that both the documentation below will ease this transition and that we've made the best choices possible for any given
scenario.

If you spot any breaking change we've not listed please let us know. Unfortunately due to the gravity of the changes
there may be breaking changes we have to add to this list.

### Secrets

As originally planned we've overhauled the secrets configuration. In part to adapt to the new changes and also to make
the feature much easier to understand. 

The chart itself is now capable of both generating multiple secrets and utilizing a mix of existing secrets and
generated ones. These settings are configured on a per configuration section basis. 

The HashiCorp Vault Injector options have been removed as they should be configurable via the relevant 
labels/annotations. If it's unclear how to achieve this then please open a discussion.

In addition you may manually add secrets as you see fit to use with the new templates filter.

The following example should allow turning any option into a secret and dynamically adding the multiline formatting 
(in the example we use an indent of 2):

```yaml
configMap:
  exampleValue: '{{ secret "/secrets/path.file" | mindent 2 "|" | msquote }}'
```

### Sessions and Domains

Several breaking changes have occurred to the domains and sessions configuration. We have no plans to support both the
single cookie domain variation and the multi cookie domain variation going forward with Authelia, the former is left as
a means to prevent a breaking change. As such we're making the hard change now for chart users.

#### Domain, Default Redirection URL, and Subdomain

The domain value has been removed and is now part of the session section. Each cookie domain configuration here will
generate relevant manifests such as ingresses. This is so we can properly facilitate the multi-cookie domain 
configurations. This also affects the default redirection URL which is no longer supported on 4.38.0 helm installations.

See below for representations of the YAML changes (before and after respectively).

```yaml
domain: example.com
ingress:
  subdomain: authelia
configMap:
  default_redirection_url: https://www.example.com
```

```yaml
configMap:
  session:
    cookies:
      - domain: example.com
        subdomain: authelia
        default_redirection_url: https://www.example.com
```

### OpenID Connect 1.0 Changes

Several OpenID Connect 1.0 changes have occurred which will not be automatically detected if you're using old values.

#### Client Auth Method

Clients will be forced to use a particular authentication method. By default all clients will use `client_secret_basic`
however this can be changed using the `token_endpoint_auth_method` parameter for each client.

Example:

```yaml
configMap:
  identity_providers:
    oidc:
      clients:
      - id: 'myid'
        token_endpoint_auth_method: 'client_secret_post'
```

#### Issuer Keys

The issuer keys have been removed from secrets. The new method of configuring them in a secrets-like fashion is to
enable the template filter and add the relevant template values. This is because we now support multiple issuer keys 
with varying algorithms. See below for representations of the new YAML values format.

Important Notes:

- Usage of the path feature requires that the `configMap.filters.enableTemplating` value is set to true which is 
  considered experimental (however has proven to be very robust).
- You can now define these values via raw values but it's not recommended.

```yaml
configMap:
  filters:
    enableTemplating: true
  identity_providers:
    oidc:
      issuer_private_keys:
      - key_id: ''
        algorithm: 'RS256'
        use: 'sig'
        key:
          path: '/secrets/oidc.issuer_key.rsa256.pem'
          # value: |
          #  -----BEGIN PRIVATE KEY-----
          #  ....
          #  -----END PRIVATE KEY-----
        certificate_chain:
          path: '/secrets/oidc.issuer_key.rsa256.crt'
          # value: |
          #   -----BEGIN CERTIFICATE-----
          #   .....
          #   -----END CERTIFICATE-----
```

#### Lifespans

The lifespans configuration has drastically changed. See below for representations of the YAML changes (before and after
respectively).

```yaml
configMap:
  identity_providers:
    oidc:
      access_token_lifespan: 1h
      authorize_code_lifespan: 1m
      id_token_lifespan: 1h
      refresh_token_lifespan: 90m
```

```yaml
configMap:
  identity_providers:
    oidc:
      lifespans:
        access_token: 1h
        authorize_code: 1m
        id_token: 1h
        refresh_token: 90m
```

## 0.5.0

- Does not support Authelia versions lower than 4.30.0
- Had several changes to the values.yaml file, specifically:
  - configMap.port is now configMap.server.port
  - configMap.log_level is now configMap.log.level
  - configMap.log_format is now configMap.log.format
  - configMap.log_file_path is now configMap.log.file_path

See the [official migration documentation](https://www.authelia.com/configuration/prologue/migration/#4300) 
(not specific to Kubernetes) for more information.

# Getting Started

1. Visit https://charts.authelia.com and follow the instructions to install the chart repo.
2. Configure the chart by setting the various [parameters](#parameters), either in a locally downloaded values.yaml or
   in the next step.
3. Install the chart with `helm install authelia authelia/authelia` and optionally set your values with `--values values.yaml` or
   via `--set [parameter]=[value]`.

## Values Files

- **values.yaml:** production environments with LDAP (auth), PostgreSQL (storage), SMTP (notification), and Redis (
  session).
- **values.local.yaml:** environments with file (auth), SQLite3 (storage), filesystem (notification), and memory (
  session).

It is expected you will configure at least the following sections/values:

- domain (this is essential for the chart to work)
- configMap section (the configMap follows a majority of the configuration options
  in [the documentation](https://www.authelia.com/configuration))
- secret section configures passwords and other secret information, configuring this directly in the configMap is not
  supported

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

## Pod

|                 Parameter                 |                          Description                           |    Default    |
|:-----------------------------------------:|:--------------------------------------------------------------:|:-------------:|
|                 pod.kind                  | Configures the kind of pod: StatefulSet, Deployment, DaemonSet |   DaemonSet   |
|              pod.annotations              |            Adds annotations specifically to the pod            |      {}       |
|                pod.labels                 |              Adds labels specifically to the pod               |      {}       |
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
|          configMap.session.redis.enabledSecret          |    Forces redis password auth using a secret if true     |       false        |
|    configMap.session.redis.high_availability.enabled    |    Enables redis sentinel when generating the config     |       false        |
| configMap.session.redis.high_availability.enabledSecret |   Forces sentinel password auth using a secret if true   |       false        |
|             configMap.storage.local.enabled             |           Enables the SQLite3 storage provider           |       false        |
|             configMap.storage.mysql.enabled             |            Enables the MySQL storage provider            |       false        |
|           configMap.storage.postgres.enabled            |         Enables the PostgreSQL storage provider          |        true        |
|          configMap.notifier.filesystem.enabled          |       Enables the filesystem notification provider       |       false        |
|             configMap.notifier.smtp.enabled             |          Enables the SMTP notification provider          |        true        |
|          configMap.notifier.smtp.enabledSecret          |     Forces smtp password auth using a secret if true     |       false        |
|        configMap.identity_providers.oidc.enabled        |              Enables the OpenID Connect Idp              |       false        |

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
