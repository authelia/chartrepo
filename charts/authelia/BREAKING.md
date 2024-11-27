# Breaking Changes

During the beta we will generally not be documenting breaking chart changes but there are exceptions and they are noted
below.

## 0.9.0

While we have aimed to keep documented backwards compatability for previous versions of Authelia deployed with the chart
we have to draw a line with this release. Due to the way the chart was designed and the introduction of multi-cookie
domains and the new authz endpoints there is just too many scenarios to handle. We're therefore cutting off support for
prior releases with this chart release as well as making several quality of life breaking changes. This was announced in
several ways and we hope the message got across.

It's difficult for users when we make breaking changes and this one is unfortunately quite substantial. We're hoping
that both the documentation below will ease this transition and that we've made the best choices possible for any given
scenario.

If you spot any breaking change we've not listed please let us know respectfully. Unfortunately due to the gravity of
the changes there may be breaking changes we have to add to this list. In addition if you were not aware of the upcoming
breaking changes and had some constructive ideas that you think would have helped then please let us know.

### Validations

Several validations have been added which will programmatically fail the chart installation if they are not satisfied.

### Miscellaneous

The following miscellaneous changes have occurred.

#### Value Key Renames

The following keys have been renamed as part of the deprecations in the Authelia configuration. This is mainly to keep
the configuration examples and values file as consistent as possible. 

|              Old Value Key               |          New Value Key          |
|:----------------------------------------:|:-------------------------------:|
| `configMap.session.remember_me_duration` | `configMap.session.remember_me` |

#### Value Key Removals

The following value keys have been removed with some notes. Most of these are just a more logical way to configure these
values long term or compatability with the newest features available in v4.38.0.

|              Value Key              |                                 Note                                  |
|:-----------------------------------:|:---------------------------------------------------------------------:|
|              `domain`               | Replaced with `configMap.session.cookies` and `ingress.rulesOverride` |
| `configMap.default_redirection_url` |               Replaced with `configMap.session.cookies`               |

#### Default Value Changes

The following default values have changed. Most of these are just to make it easier for users to configure exactly
the option they want rather than having to wrestle the chart into obedience.

|                    Value Key                    | Old Default Value | New Default Value |
|:-----------------------------------------------:|:-----------------:|:-----------------:|
|        `configMap.session.redis.enabled`        |      `true`       |      `false`      |
|        `configMap.notifier.smtp.enabled`        |      `true`       |      `false`      |
| `configMap.authentication_backend.ldap.enabled` |      `true`       |      `false`      |
|      `configMap.storage.postgres.enabled`       |      `true`       |      `false`      |

### Secrets

As originally planned we've overhauled the secrets configuration. In part to adapt to the new changes and also to make
the feature much easier to understand.

These changes are separated into two distinct elements:

1. The secrets are now local to where they're used in the configuration instead of in a single location.
   1. This has the advantage of if you're for example configuring PostgreSQL that you configure the username and 
      password at the same time.
2. The implementation specifics have been adjusted so the syntax for all secrets is generally the same.
3. You're able to include varied secrets instead of the single secret like before.

The following section shows a before and after look at the secret generation method.

Before:

```yaml
name:
  key: 'KEY_NAME'
  value: ""
  filename: 'FILE_NAME'
```

After:

```yaml
secret:
  ## Disables this secret allowing you to handle it yourself in any way you see fit.
  disabled: false
  
  ## Sets the name of the secret to use. The ~ value indicates the internal secret. Value will be mounted into the 
  ## '/secrets/<secret_name>/<path>' location, where secret_name for ~ is 'internal'.
  secret_name: ~
  
  ## When using the internal secret this allows setting the value arbitrarily. Only required on the first `helm install`
  ## or `helm upgrade`, after which it's only required to overwrite it.
  value: ''
  
  ## Key name within the secret which is the mounted location.
  path: 'FILE_NAME'
```

The chart itself is now capable of both generating multiple secrets and utilizing a mix of existing secrets and
generated ones. These settings are configured on a per configuration section basis specifically in the configMap
section. Above is an example of the way a secret is loaded into the Authelia config, and an example usage can be seen
with `.configMap.storage.postgres.password`.

The HashiCorp Vault Injector options have been removed as they should be configurable via the relevant
labels/annotations. If it's unclear how to achieve a specific chart output value that you need for this purpose please
let us know the specific output you're after in a [discussion](https://github.com/authelia/authelia/discussions) (we are
not experts at HashiCorp Vault, so if you're unsure of the specific output you need you can still ask but we may just
not be able to help).

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

See below for representations of the YAML changes.

Before:

```yaml
domain: 'example.com'
ingress:
  subdomain: 'authelia'
configMap:
  default_redirection_url: 'https://www.example.com'
```

After:

```yaml
configMap:
  session:
    cookies:
      - domain: 'example.com'
        subdomain: 'authelia'
        default_redirection_url: 'https://www.example.com'
```

### OpenID Connect 1.0 Changes

Several OpenID Connect 1.0 changes have occurred which will not be automatically detected if you're using old values and
may cause an error if you're still using them.

#### Client Option: id and secret

Client options `id` and `secret` have been renamed to `client_id` and `client_secert` respectively to closely match the
specification. In addition the `client_secret` must use one of the hash formats (even if it's the `$plaintext$` format).

Before:

```yaml
configMap:
  identity_providers:
    oidc:
      clients:
      - id: 'myid'
        secret: '$pbkdf2-sha512$310000$c8p78n7pUMln0jzvd4aK4Q$JNRBzwAo0ek5qKn50cFzzvE9RXV88h1wJn5KGiHrD0YKtZaR/nCb2CJPOsKaPK0hjf.9yHxzQGZziziccp6Yng'
```

After:

```yaml
configMap:
  identity_providers:
    oidc:
      clients:
      - client_id: 'myid'
        client_secret: '$pbkdf2-sha512$310000$c8p78n7pUMln0jzvd4aK4Q$JNRBzwAo0ek5qKn50cFzzvE9RXV88h1wJn5KGiHrD0YKtZaR/nCb2CJPOsKaPK0hjf.9yHxzQGZziziccp6Yng'
```

#### Client Option: token_endpoint_auth_method

Clients will be forced to use a specific authentication method. By default all clients will use `client_secret_post`
however this can be changed using the `token_endpoint_auth_method` parameter for each client. This is probably the most
impactful change as you'll need to consult the documentation for the third party application to determine what method
it utilizes. Generally speaking the `client_secret_post` (also known as in form/body) should work, otherwise it's likely
`client_secret_basic` (also known as header or in header).

Example:

```yaml
configMap:
  identity_providers:
    oidc:
      clients:
      - client_id: 'myid'
        token_endpoint_auth_method: 'client_secret_basic'
```

#### Client Option: secret

The secret must now be prefixed with a hashing prefix. You may choose to prefix it with `$plaintext$` but we're strongly
urging users to use a proper hash as this option will not be permitted in the near future except for clients using the
`client_secret_jwt` authentication method for the `token_endpoint_auth_method` option.

In addition client secrets can now be specified via a path which you've mounted into the Pods. This option is backwards
compatible and allows either specifying it directly as a value or using the dictionary structure. Example with commented
alternatives below.

```yaml
configMap:
  identity_providers:
    oidc:
      clients:
      - client_id: 'example'
        # secret: '$pbkdf2-sha512$310000$c8p78n7pUMln0jzvd4aK4Q$JNRBzwAo0ek5qKn50cFzzvE9RXV88h1wJn5KGiHrD0YKtZaR/nCb2CJPOsKaPK0hjf.9yHxzQGZziziccp6Yng'  # The digest of 'insecure_secret'.
        client_secret:
          # value: '$pbkdf2-sha512$310000$c8p78n7pUMln0jzvd4aK4Q$JNRBzwAo0ek5qKn50cFzzvE9RXV88h1wJn5KGiHrD0YKtZaR/nCb2CJPOsKaPK0hjf.9yHxzQGZziziccp6Yng'  # The digest of 'insecure_secret'.
          path: '/path/to/secret'
```

#### Client Option: userinfo_signing_algorithm

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
