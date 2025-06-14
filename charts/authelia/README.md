# authelia

![Version: 0.10.14](https://img.shields.io/badge/Version-0.10.14-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 4.39.4](https://img.shields.io/badge/AppVersion-4.39.4-informational?style=flat-square)

Authelia is a Single Sign-On Multi-Factor portal for web apps

**Homepage:** <https://www.authelia.com>

## Breaking Changes

Breaking changes with this chart should be expected during the v0.x.x versions at any time however we aim to keep the
breaking changes within minor releases i.e. from v0.1.0 to v0.2.0. The following versions have notable breaking changes
which users should be aware of:

- [v0.10.0](https://github.com/authelia/chartrepo/blob/master/charts/authelia/BREAKING.md#0100)
- [v0.9.0](https://github.com/authelia/chartrepo/blob/master/charts/authelia/BREAKING.md#090)
- [v0.5.0](https://github.com/authelia/chartrepo/blob/master/charts/authelia/BREAKING.md#050)

## Getting Started

1. Visit https://charts.authelia.com and follow the instructions to install the chart repo.
2. Configure the chart by setting the various [parameters](#parameters), either in a locally downloaded values.yaml or
   in the next step.
3. Install the chart with `helm install authelia authelia/authelia` and optionally set your values with `--values values.yaml` or
   via `--set [parameter]=[value]`.

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| James Elliott | <james-d-elliott@users.noreply.github.com> | <https://github.com/james-d-elliott> |

## Source Code

* <https://github.com/authelia/chartrepo/tree/master/charts/authelia>
* <https://www.github.com/authelia/authelia>

## Requirements

Kubernetes: `>= 1.13.0-0`

| Repository | Name | Version |
|------------|------|---------|
| https://charts.bitnami.com/bitnami | mariadb | ~18.2.4 |
| https://charts.bitnami.com/bitnami | postgresql | ~15.5.11 |
| https://charts.bitnami.com/bitnami | redis | ~19.6.0 |

## Values Files

- **values.yaml:** basic template with no specific feature states enabled.
- **values.local.yaml:** environments with file (auth), SQLite3 (storage), filesystem (notification), and memory (
  session).

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| annotations | object | `{}` | Extra annotations for all generated resources. Most manifest types have a more specific annotations value associated with them. |
| appNameOverride | string | `nil` | The app name override for this deployment. |
| certificates.annotations | object | `{}` | Extra annotations for the Certificates Secret manifest. |
| certificates.existingSecret | string | `""` | Name of an existing Secret manifest to mount which contains trusted certificates. |
| certificates.labels | object | `{}` | Extra labels for the Certificates Secret manifest. |
| certificates.values | list | `[]` | List of secret name value pairs to include in this Secret manifest. |
| configMap.access_control.default_policy | string | `"deny"` | Default policy can either be 'bypass', 'one_factor', 'two_factor' or 'deny'. It is the policy applied to any resource if there is no policy to be applied to the user. |
| configMap.access_control.rules | list | `[]` | Access Control Rule list. |
| configMap.access_control.secret.enabled | bool | `false` | Enables the ACL section being generated as a secret. |
| configMap.access_control.secret.existingSecret | string | `""` | An existingSecret name, if configured this will force the secret to be mounted using the key above. |
| configMap.access_control.secret.key | string | `"configuration.acl.yaml"` | The key in the secret which contains the file to mount. |
| configMap.annotations | object | `{}` | Extra annotations for the ConfigMap manifest. |
| configMap.authentication_backend.file.enabled | bool | `false` | Enable File Backend (Authentication). |
| configMap.authentication_backend.file.extra_attributes | object | `{}` | The extra attributes to load from the directory server. These extra attributes can be used in other areas of Authelia such as OpenID Connect 1.0. It’s also recommended to check out the Attributes Reference Guide for more information. |
| configMap.authentication_backend.file.password.algorithm | string | `"argon2"` | Controls the hashing algorithm used for hashing new passwords. |
| configMap.authentication_backend.file.password.argon2.iterations | int | `3` | Controls the number of iterations when hashing passwords using Argon2. |
| configMap.authentication_backend.file.password.argon2.key_length | int | `32` | Controls the output key length when hashing passwords using Argon2. |
| configMap.authentication_backend.file.password.argon2.memory | int | `65536` | Controls the amount of memory in kibibytes when hashing passwords using Argon2. |
| configMap.authentication_backend.file.password.argon2.parallelism | int | `4` | Controls the parallelism factor when hashing passwords using Argon2. |
| configMap.authentication_backend.file.password.argon2.salt_length | int | `16` | Controls the output salt length when hashing passwords using Argon2 |
| configMap.authentication_backend.file.password.argon2.variant | string | `"argon2id"` | Controls the variant when hashing passwords using Argon2. Recommended argon2id. Permitted values argon2id, argon2i, argon2d. |
| configMap.authentication_backend.file.password.bcrypt.cost | int | `12` | Controls the hashing cost when hashing passwords using Bcrypt. |
| configMap.authentication_backend.file.password.bcrypt.variant | string | `"standard"` | Controls the variant when hashing passwords using Bcrypt. Recommended standard. Permitted values standard, sha256. |
| configMap.authentication_backend.file.password.pbkdf2.iterations | int | `310000` | Controls the number of iterations when hashing passwords using PBKDF2. |
| configMap.authentication_backend.file.password.pbkdf2.salt_length | int | `16` | Controls the output salt length when hashing passwords using PBKDF2. |
| configMap.authentication_backend.file.password.pbkdf2.variant | string | `"sha512"` | Controls the variant when hashing passwords using PBKDF2. Recommended sha512. Permitted values sha1, sha224, sha256, sha384, sha512. |
| configMap.authentication_backend.file.password.scrypt.block_size | int | `8` | Controls the block size when hashing passwords using Scrypt. |
| configMap.authentication_backend.file.password.scrypt.iterations | int | `16` | Controls the number of iterations when hashing passwords using Scrypt. |
| configMap.authentication_backend.file.password.scrypt.key_length | int | `32` | Controls the output key length when hashing passwords using Scrypt. |
| configMap.authentication_backend.file.password.scrypt.parallelism | int | `1` | Controls the parallelism factor when hashing passwords using Scrypt. |
| configMap.authentication_backend.file.password.scrypt.salt_length | int | `16` | Controls the output salt length when hashing passwords using Scrypt. |
| configMap.authentication_backend.file.password.scrypt.variant | string | `"scrypt"` | Controls the variant when hashing passwords using Scrypt. Permitted values scrypt, yescrypt. |
| configMap.authentication_backend.file.password.sha2crypt.iterations | int | `50000` | Controls the number of iterations when hashing passwords using SHA2 Crypt. |
| configMap.authentication_backend.file.password.sha2crypt.salt_length | int | `16` | Controls the output salt length when hashing passwords using SHA2 Crypt. |
| configMap.authentication_backend.file.password.sha2crypt.variant | string | `"sha512"` | Controls the variant when hashing passwords using SHA2 Crypt. Recommended sha512. Permitted values sha256, sha512. |
| configMap.authentication_backend.file.path | string | `"/config/users_database.yml"` | The path to the file with the user details list. |
| configMap.authentication_backend.file.search.case_insensitive | bool | `false` | Enabling this search option allows users to login with their username regardless of case. If enabled users must only have lowercase usernames. |
| configMap.authentication_backend.file.search.email | bool | `false` | Allows users to login using their email address. If enabled two users must not have the same emails and their usernames must not be an email. |
| configMap.authentication_backend.file.watch | bool | `false` | Enables reloading the database by watching it for changes. |
| configMap.authentication_backend.ldap.additional_groups_dn | string | `"OU=Groups"` | An additional dn to define the scope of groups. |
| configMap.authentication_backend.ldap.additional_users_dn | string | `"OU=Users"` | An additional dn to define the scope to all users. |
| configMap.authentication_backend.ldap.address | string | `"ldap://openldap.default.svc.cluster.local"` | The address for the ldap server. Format: <scheme>://<address>[:<port>]. Scheme can be ldap or ldaps in the format (port optional). |
| configMap.authentication_backend.ldap.attributes.birthdate | string | `""` | The attribute holding the birthdate of the user. |
| configMap.authentication_backend.ldap.attributes.country | string | `""` | The attribute holding the country of the user. |
| configMap.authentication_backend.ldap.attributes.display_name | string | `""` | The attribute holding the display name of the user. This will be used to greet an authenticated user. |
| configMap.authentication_backend.ldap.attributes.distinguished_name | string | `""` | The attribute holding the distinguished name of the user. |
| configMap.authentication_backend.ldap.attributes.extra | object | `{}` | The extra attributes for users. |
| configMap.authentication_backend.ldap.attributes.family_name | string | `""` | The attribute holding the family name of the user. |
| configMap.authentication_backend.ldap.attributes.gender | string | `""` | The attribute holding the gender of the user. |
| configMap.authentication_backend.ldap.attributes.given_name | string | `""` | The attribute holding the given name of the user. |
| configMap.authentication_backend.ldap.attributes.group_name | string | `""` | The attribute holding the name of the group. |
| configMap.authentication_backend.ldap.attributes.locale | string | `""` | The attribute holding the locale of the user. |
| configMap.authentication_backend.ldap.attributes.locality | string | `""` | The attribute holding the locality of the user. |
| configMap.authentication_backend.ldap.attributes.mail | string | `""` | The attribute holding the mail address of the user. If multiple email addresses are defined for a user, only the first one returned by the LDAP server is used. |
| configMap.authentication_backend.ldap.attributes.member_of | string | `""` | The attribute which represents the objects this user is a member of. |
| configMap.authentication_backend.ldap.attributes.middle_name | string | `""` | The attribute holding the middle name of the user. |
| configMap.authentication_backend.ldap.attributes.nickname | string | `""` | The attribute holding the nickname of the user. |
| configMap.authentication_backend.ldap.attributes.phone_extension | string | `""` | The attribute holding the phone extension of the user. |
| configMap.authentication_backend.ldap.attributes.phone_number | string | `""` | The attribute holding the phone number of the user. |
| configMap.authentication_backend.ldap.attributes.picture | string | `""` | The attribute holding the picture URL of the user. |
| configMap.authentication_backend.ldap.attributes.postal_code | string | `""` | The attribute holding the postal code of the user. |
| configMap.authentication_backend.ldap.attributes.profile | string | `""` | The attribute holding the profile of the user. |
| configMap.authentication_backend.ldap.attributes.region | string | `""` | The attribute holding the region of the user. |
| configMap.authentication_backend.ldap.attributes.street_address | string | `""` | The attribute holding the street address of the user. |
| configMap.authentication_backend.ldap.attributes.username | string | `""` | The attribute holding the username of the user. This attribute is used to populate the username in the session information. |
| configMap.authentication_backend.ldap.attributes.website | string | `""` | The attribute holding the website of the user. |
| configMap.authentication_backend.ldap.attributes.zoneinfo | string | `""` | The attribute holding the zoneinfo of the user. |
| configMap.authentication_backend.ldap.base_dn | string | `"DC=example,DC=com"` | The base dn for every LDAP query. |
| configMap.authentication_backend.ldap.enabled | bool | `false` | Enable LDAP Backend. |
| configMap.authentication_backend.ldap.groups_filter | string | `""` | The groups filter used in search queries to find the groups of the user. |
| configMap.authentication_backend.ldap.implementation | string | `"activedirectory"` | The LDAP implementation, this affects elements like the attribute utilised for resetting a password. |
| configMap.authentication_backend.ldap.password.disabled | bool | `false` | Disables this secret and leaves configuring it entirely up to you. |
| configMap.authentication_backend.ldap.password.path | string | `"authentication.ldap.password.txt"` | The path to the secret. If it has a '/' prefix it's assumed to be an absolute path within the pod. Otherwise it uses the format '{mountPath}/{secret_name}/{path}' where '{mountPath}' refers to the 'secret.mountPath' value, '{secret_name}' is the secret_name above, and '{path}' is this value. |
| configMap.authentication_backend.ldap.password.secret_name | string | `nil` | The secret name. The ~ name is special as it is the secret we generate either automatically or via the secret_value option below. |
| configMap.authentication_backend.ldap.password.value | string | `""` | The value of a generated secret when using the ~ secret_name. |
| configMap.authentication_backend.ldap.permit_feature_detection_failure | bool | `false` | This option is strongly discouraged. If enabled it will ignore errors looking up the RootDSE for supported controls/extensions. |
| configMap.authentication_backend.ldap.permit_referrals | bool | `false` | Follow referrals returned by the server. This is especially useful for environments where read-only servers exist. Only implemented for write operations. |
| configMap.authentication_backend.ldap.permit_unauthenticated_bind | bool | `false` | Permits use of an unauthenticated bind. WARNING: This option is strongly discouraged. Please consider disabling unauthenticated binding to your LDAP server and utilizing a service account. |
| configMap.authentication_backend.ldap.pooling.count | int | `5` | The number of open connections to be available in the pool at any given time. |
| configMap.authentication_backend.ldap.pooling.enable | bool | `false` | Enables the connection pooling functionality. |
| configMap.authentication_backend.ldap.pooling.retries | int | `2` | The number of attempts to obtain a free connecting that are made within the timeout period. This effectively splits the timeout into chunks. |
| configMap.authentication_backend.ldap.pooling.timeout | string | `"10 seconds"` | The amount of time that we wait for a connection to become free in the pool before giving up and failing with an error. |
| configMap.authentication_backend.ldap.start_tls | bool | `false` | Use StartTLS with the LDAP connection. |
| configMap.authentication_backend.ldap.timeout | string | `"5 seconds"` | Connection Timeout. |
| configMap.authentication_backend.ldap.tls.maximum_version | string | `"TLS1.3"` | Maximum TLS version for the connection. |
| configMap.authentication_backend.ldap.tls.minimum_version | string | `"TLS1.2"` | Minimum TLS version for the connection. |
| configMap.authentication_backend.ldap.tls.server_name | string | `""` | The server subject name to check the servers certificate against during the validation process. This option is not required if the certificate has a SAN which matches the host portion of the url option. |
| configMap.authentication_backend.ldap.tls.skip_verify | bool | `false` | Skip verifying the server certificate entirely. |
| configMap.authentication_backend.ldap.user | string | `"CN=Authelia,DC=example,DC=com"` | The username of the admin user. |
| configMap.authentication_backend.ldap.users_filter | string | `""` | The users filter used in search queries to find the user profile based on input filled in login form. |
| configMap.authentication_backend.password_change.disable | bool | `false` | Disable both the HTML element and the API for change password functionality. |
| configMap.authentication_backend.password_reset.custom_url | string | `""` | External reset password url that redirects the user to an external reset portal. This disables the internal reset functionality. |
| configMap.authentication_backend.password_reset.disable | bool | `false` | Disable both the HTML element and the API for reset password functionality. |
| configMap.authentication_backend.refresh_interval | string | `"5 minutes"` | The amount of time to wait before we refresh data from the authentication backend. Uses duration notation. |
| configMap.default_2fa_method | string | `""` | Set the default 2FA method for new users and for when a user has a preferred method configured that has been disabled. This setting must be a method that is enabled. Options are totp, webauthn, mobile_push. |
| configMap.definitions.network | object | `{}` | The network section configures named network lists. |
| configMap.definitions.user_attributes | object | `{}` | The user attributes section allows you to define custom attributes for your users using Common Expression Language (CEL). |
| configMap.disabled | bool | `false` | Disable the configMap source for the Authelia config. If this is false you need to provide a volumeMount via PV/PVC or other means that mounts to /config. |
| configMap.duo_api.enable_self_enrollment | bool | `false` | Enables Duo device self-enrollment from within the Authelia portal. |
| configMap.duo_api.enabled | bool | `false` | Enables Duo. |
| configMap.duo_api.hostname | string | `""` | The Duo API hostname. This is provided in the Duo dashboard. |
| configMap.duo_api.integration_key | string | `""` | The non-secret Duo integration key. Similar to a client identifier. This is provided in the Duo dashboard. |
| configMap.duo_api.secret.disabled | bool | `false` | Disables this secret and leaves configuring it entirely up to you. |
| configMap.duo_api.secret.path | string | `"duo.key"` | The path to the secret. If it has a '/' prefix it's assumed to be an absolute path within the pod. Otherwise it uses the format '{mountPath}/{secret_name}/{path}' where '{mountPath}' refers to the 'secret.mountPath' value, '{secret_name}' is the secret_name above, and '{path}' is this value. |
| configMap.duo_api.secret.secret_name | string | `nil` | The secret name. The ~ name is special as it is the secret we generate either automatically or via the secret_value option below. |
| configMap.duo_api.secret.value | string | `""` | The value of a generated secret when using the ~ secret_name. |
| configMap.existingConfigMap | string | `""` | The name of an existing ConfigMap instead of generating one. |
| configMap.extraConfigs | list | `[]` | The paths of extra configs that are mounted into the Pod which should be used. |
| configMap.filters.disabled | bool | `false` | Disables the template filters. This is not recommended. |
| configMap.identity_providers.oidc.authorization_policies | object | `{}` | Authorization Policies configuration. |
| configMap.identity_providers.oidc.claims_policies | object | `{}` | The claims policies are policies which allow customizing the behaviour of claims and the available claims for a particular client. |
| configMap.identity_providers.oidc.clients | list | `[]` | List of registered clients for this provider. |
| configMap.identity_providers.oidc.cors.allowed_origins | list | `[]` | List of allowed origins. Any origin with https is permitted unless this option is configured or the allowed_origins_from_client_redirect_uris option is enabled. |
| configMap.identity_providers.oidc.cors.allowed_origins_from_client_redirect_uris | bool | `false` | Automatically adds the origin portion of all redirect URI's on all clients to the list of allowed_origins, provided they have the scheme http or https and do not have the hostname of localhost. |
| configMap.identity_providers.oidc.cors.endpoints | list | `[]` | List of endpoints in addition to the metadata endpoints to permit cross-origin requests on. |
| configMap.identity_providers.oidc.enable_client_debug_messages | bool | `false` | Enables additional debug messages. SECURITY NOTICE: It's not recommended to use this in production as it may leak configuration information to clients. |
| configMap.identity_providers.oidc.enable_pkce_plain_challenge | bool | `false` | Enables the plain PKCE challenge which is not recommended for security reasons but may be necessary for some clients. |
| configMap.identity_providers.oidc.enabled | bool | `false` | Enables this in the config map. Currently in beta stage. See https://www.authelia.com/r/openid-connect/ |
| configMap.identity_providers.oidc.enforce_pkce | string | `"public_clients_only"` | Adjusts the PKCE enforcement. Options are always, public_clients_only, never. For security reasons it's recommended this option is public_clients_only or always, however always is not compatible with all clients. |
| configMap.identity_providers.oidc.hmac_secret.disabled | bool | `false` | Disables this secret and leaves configuring it entirely up to you. |
| configMap.identity_providers.oidc.hmac_secret.path | string | `"identity_providers.oidc.hmac.key"` | The path to the secret. If it has a '/' prefix it's assumed to be an absolute path within the pod. Otherwise it uses the format '{mountPath}/{secret_name}/{path}' where '{mountPath}' refers to the 'secret.mountPath' value, '{secret_name}' is the secret_name above, and '{path}' is this value. |
| configMap.identity_providers.oidc.hmac_secret.secret_name | string | `nil` | The secret name. The ~ name is special as it is the secret we generate either automatically or via the secret_value option below. |
| configMap.identity_providers.oidc.hmac_secret.value | string | `""` | The value of a generated secret when using the ~ secret_name. |
| configMap.identity_providers.oidc.jwks | list | `[]` | The JWK's issuer option configures multiple JSON Web Keys. It's required that at least one of the JWK's configured has the RS256 algorithm. For RSA keys (RS or PS) the minimum is a 2048 bit key. |
| configMap.identity_providers.oidc.lifespans.access_token | string | `"1 hour"` | Default lifespan for Access Tokens. |
| configMap.identity_providers.oidc.lifespans.authorize_code | string | `"1 minute"` | Default lifespan for Authorize Codes. |
| configMap.identity_providers.oidc.lifespans.custom | object | `{}` | The custom lifespan configuration allows customizing the lifespans per-client. The custom lifespans must be utilized with the client lifespan option which applies those settings to that client. Custom lifespans can be configured in a very granular way, either solely by the token type, or by the token type for each grant type. |
| configMap.identity_providers.oidc.lifespans.device_code | string | `"10 minutes"` | Default lifespan for Device Codes. |
| configMap.identity_providers.oidc.lifespans.id_token | string | `"1 hour"` | Default lifespan for ID Tokens. |
| configMap.identity_providers.oidc.lifespans.refresh_token | string | `"1 hour and 30 minutes"` | Default lifespan for Refresh Tokens. |
| configMap.identity_providers.oidc.minimum_parameter_entropy | int | `8` | Adjusts the parameter entropy requirements for nonce/state etc. SECURITY NOTICE: It's not recommended changing this option, and highly discouraged to have it less than 8. |
| configMap.identity_providers.oidc.pushed_authorizations.context_lifespan | string | `"5 minutes"` | Adjusts the lifespan for a Pushed Authorization session / context. |
| configMap.identity_providers.oidc.pushed_authorizations.enforce | bool | `false` | Requires Pushed Authorization Requests for all Authorization Flows. |
| configMap.identity_providers.oidc.scopes | object | `{}` | A list of scope definitions available in addition to the standard ones. |
| configMap.identity_validation.elevated_session.characters | int | `8` | The number of characters the random One-Time Code has. Maximum value is currently 20, but we recommend keeping it between 8 and 12. It’s strongly discouraged to reduce it below 8. |
| configMap.identity_validation.elevated_session.code_lifespan | string | `"5 minutes"` | The lifespan of the randomly generated One Time Code after which it’s considered invalid. |
| configMap.identity_validation.elevated_session.elevation_lifespan | string | `"10 minutes"` | The lifespan of the elevation after initially validating the One-Time Code before it expires. |
| configMap.identity_validation.elevated_session.require_second_factor | bool | `false` | Requires second factor authentication for all protected actions in addition to the elevated session provided the user has configured a second factor authentication method. |
| configMap.identity_validation.elevated_session.skip_second_factor | bool | `false` | Skips the elevated session requirement if the user has performed second factor authentication. Can be combined with the require_second_factor option to always (and only) require second factor authentication. |
| configMap.identity_validation.reset_password.jwt_algorithm | string | `"HS256"` | The JSON Web Token Algorithm used to sign the JWT. Must be HS256, HS384, or HS512. |
| configMap.identity_validation.reset_password.jwt_lifespan | string | `"5 minutes"` | The lifespan of the JSON Web Token after it’s initially generated after which it’s considered invalid. |
| configMap.identity_validation.reset_password.secret.disabled | bool | `false` | Disables this secret and leaves configuring it entirely up to you. |
| configMap.identity_validation.reset_password.secret.path | string | `"identity_validation.reset_password.jwt.hmac.key"` | The path to the secret. If it has a '/' prefix it's assumed to be an absolute path within the pod. Otherwise it uses the format '{mountPath}/{secret_name}/{path}' where '{mountPath}' refers to the 'secret.mountPath' value, '{secret_name}' is the secret_name above, and '{path}' is this value. |
| configMap.identity_validation.reset_password.secret.secret_name | string | `nil` | The secret name. The ~ name is special as it is the secret we generate either automatically or via the secret_value option below. |
| configMap.identity_validation.reset_password.secret.value | string | `""` | The value of a generated secret when using the ~ secret_name. |
| configMap.key | string | `"configuration.yaml"` | The key from the ConfigMap manifest to generate and mount the configuration. |
| configMap.labels | object | `{}` | Extra labels for the ConfigMap manifest. |
| configMap.log.file_path | string | `""` | File path where the logs will be written. If not set logs are written to stdout. |
| configMap.log.format | string | `"text"` | Format the logs are written as: json, text. |
| configMap.log.level | string | `"info"` | Level of verbosity for logs: info, debug, trace. |
| configMap.notifier.disable_startup_check | bool | `false` | You can disable the notifier startup check by setting this to true. |
| configMap.notifier.filesystem.enabled | bool | `false` | Enables the File System Provider (Notifier). |
| configMap.notifier.filesystem.filename | string | `"/config/notification.txt"` | The file to add email text to. If it doesn’t exist it will be created. |
| configMap.notifier.smtp.address | string | `"submission://smtp.mail.svc.cluster.local:587"` | Configures the address for the SMTP Server. The address itself is a connector and the scheme must be smtp, submission, or submissions. The only difference between these schemes are the default ports and submissions requires a TLS transport per SMTP Ports Security Measures, whereas submission and smtp use a standard TCP transport and typically enforce StartTLS. |
| configMap.notifier.smtp.disable_html_emails | bool | `false` | Disables sending HTML formatted emails. |
| configMap.notifier.smtp.disable_require_tls | bool | `false` | By default we require some form of TLS. This disables this check though is not advised. |
| configMap.notifier.smtp.disable_starttls | bool | `false` | Some SMTP servers ignore SMTP specifications and claim to support STARTTLS when they in fact do not. For security reasons Authelia refuses to send messages to these servers. This option disables this measure and is enabled AT YOUR OWN RISK. |
| configMap.notifier.smtp.enabled | bool | `false` | Enables the SMTP Provider (Notifier). |
| configMap.notifier.smtp.identifier | string | `"localhost"` | HELO/EHLO Identifier. Some SMTP Servers may reject the default of localhost. |
| configMap.notifier.smtp.password.disabled | bool | `false` | Disables this secret and leaves configuring it entirely up to you. |
| configMap.notifier.smtp.password.path | string | `"notifier.smtp.password.txt"` | The path to the secret. If it has a '/' prefix it's assumed to be an absolute path within the pod. Otherwise it uses the format '{mountPath}/{secret_name}/{path}' where '{mountPath}' refers to the 'secret.mountPath' value, '{secret_name}' is the secret_name above, and '{path}' is this value. |
| configMap.notifier.smtp.password.secret_name | string | `nil` | The secret name. The ~ name is special as it is the secret we generate either automatically or via the secret_value option below. |
| configMap.notifier.smtp.password.value | string | `""` | The value of a generated secret when using the ~ secret_name. |
| configMap.notifier.smtp.sender | string | `"Authelia <admin@example.com>"` | The sender is used to construct both the SMTP command MAIL FROM and to add the FROM header. This address must be in RFC5322 format. |
| configMap.notifier.smtp.startup_check_address | string | `"test@authelia.com"` | This address is used during the startup check to verify the email configuration is correct. It's not important what it is except if your email server only allows local delivery. |
| configMap.notifier.smtp.subject | string | `"[Authelia] {title}"` | Subject configuration of the emails sent. {title} is replaced by the text from the notifier |
| configMap.notifier.smtp.timeout | string | `"5 seconds"` | The SMTP connection timeout. |
| configMap.notifier.smtp.tls.maximum_version | string | `"TLS1.3"` | Maximum TLS version for the connection. |
| configMap.notifier.smtp.tls.minimum_version | string | `"TLS1.2"` | Minimum TLS version for the connection. |
| configMap.notifier.smtp.tls.server_name | string | `""` | The server subject name to check the servers certificate against during the validation process. This option is not required if the certificate has a SAN which matches the host option. |
| configMap.notifier.smtp.tls.skip_verify | bool | `false` | Skip verifying the server certificate entirely. |
| configMap.notifier.smtp.username | string | `""` | The username sent for authentication with the SMTP server. Paired with the password. |
| configMap.ntp.address | string | `"udp://time.cloudflare.com:123"` | NTP server address. |
| configMap.ntp.disable_failure | bool | `false` | The default of false will prevent startup only if we can contact the NTP server and the time is out of sync with the NTP server more than the configured max_desync. If you set this to true, an error will be logged but startup will continue regardless of results. |
| configMap.ntp.disable_startup_check | bool | `false` | Disables the NTP check on startup entirely. This means Authelia will not contact a remote service at all if you set this to true, and can operate in a truly offline mode. |
| configMap.ntp.max_desync | string | `"3 seconds"` | Maximum allowed time offset between the host and the NTP server. |
| configMap.ntp.version | int | `4` | NTP version. |
| configMap.password_policy.standard.enabled | bool | `false` | Enables standard password policy. |
| configMap.password_policy.standard.max_length | int | `0` | Require a maximum length for passwords. |
| configMap.password_policy.standard.min_length | int | `8` | Require a minimum length for passwords. |
| configMap.password_policy.standard.require_lowercase | bool | `false` | Require lowercase characters. |
| configMap.password_policy.standard.require_number | bool | `false` | Require numeric characters. |
| configMap.password_policy.standard.require_special | bool | `false` | Require special characters. |
| configMap.password_policy.standard.require_uppercase | bool | `false` | Require uppercase characters. |
| configMap.password_policy.zxcvbn.enabled | bool | `false` | Enables zxcvbn password policy. |
| configMap.password_policy.zxcvbn.min_score | int | `0` | Configures the minimum score allowed. |
| configMap.regulation.ban_time | string | `"5 minutes"` | The length of time before a banned user can login again. Ban Time accepts duration notation. See: https://www.authelia.com/configuration/prologue/common/#duration-notation-format |
| configMap.regulation.find_time | string | `"2 minutes"` | The time range during which the user can attempt login before being banned. The user is banned if the authentication failed 'max_retries' times in a 'find_time' seconds window. Find Time accepts duration notation. See: https://www.authelia.com/configuration/prologue/common/#duration-notation-format |
| configMap.regulation.max_retries | int | `3` | The number of failed login attempts before user is banned. Set it to 0 to disable regulation. |
| configMap.regulation.modes | list | `["user"]` | The regulation modes to use. The active modes determines what is banned in the event of a regulation ban being triggered as well as what logs to inspect to determine if a ban is needed. Default is just user, but ip is also available. |
| configMap.server.asset_path | string | `""` | Set the path on disk to Authelia assets. Useful to allow overriding of specific static assets. |
| configMap.server.buffers.read | int | `4096` | Read buffer. |
| configMap.server.buffers.write | int | `4096` | Write buffer. |
| configMap.server.endpoints.authz | object | `{}` | Dictionary of individually configured Authz endpoints. |
| configMap.server.endpoints.automatic_authz_implementations | list | `[]` | A list of automatically configured authz implementations if you don't wish to manually configure each one. Important Note: If you configure the 'authz' section this is completely ignored. |
| configMap.server.endpoints.enable_expvars | bool | `false` | Enable the developer expvars handlers. |
| configMap.server.endpoints.enable_pprof | bool | `false` | Enable the developer pprof handlers. |
| configMap.server.headers.csp_template | string | `""` | Read the Authelia docs before setting this advanced option. https://www.authelia.com/configuration/miscellaneous/server/#csp_template. |
| configMap.server.path | string | `""` | Set the single level path Authelia listens on.  Must be alphanumeric chars and should not contain any slashes. |
| configMap.server.port | int | `9091` | Port sets the configured port for the daemon, service, and the probes. Default is 9091 and should not need to be changed. |
| configMap.server.timeouts.idle | string | `"30 seconds"` | Idle timeout. |
| configMap.server.timeouts.read | string | `"6 seconds"` | Read timeout. |
| configMap.server.timeouts.write | string | `"6 seconds"` | Write timeout. |
| configMap.session.cookies | list | `[]` | Session Cookies list. |
| configMap.session.encryption_key.disabled | bool | `false` | Disables this secret and leaves configuring it entirely up to you. |
| configMap.session.encryption_key.path | string | `"session.encryption.key"` | The path to the secret. If it has a '/' prefix it's assumed to be an absolute path within the pod. Otherwise it uses the format '{mountPath}/{secret_name}/{path}' where '{mountPath}' refers to the 'secret.mountPath' value, '{secret_name}' is the secret_name above, and '{path}' is this value. |
| configMap.session.encryption_key.secret_name | string | `nil` | The secret name. The ~ name is special as it is the secret we generate either automatically or via the secret_value option below. |
| configMap.session.encryption_key.value | string | `""` | The value of a generated secret when using the ~ secret_name. |
| configMap.session.expiration | string | `"1 hour"` | The time in seconds before the cookie expires and session is reset. |
| configMap.session.inactivity | string | `"5 minutes"` | The inactivity time in seconds before the session is reset. |
| configMap.session.name | string | `"authelia_session"` | The name of the session cookie. (default: authelia_session). |
| configMap.session.redis.database_index | int | `0` | This is the Redis DB Index https://redis.io/commands/select (sometimes referred to as database number, DB, etc). |
| configMap.session.redis.deploy | bool | `false` | Deploy the redis bitnami chart. |
| configMap.session.redis.enabled | bool | `false` | Enable the use of redis. |
| configMap.session.redis.high_availability.enabled | bool | `false` | Enable the use of redis sentinel. |
| configMap.session.redis.high_availability.nodes | list | `[]` | The additional nodes to pre-seed the redis provider with (for sentinel). If the host in the above section is defined, it will be combined with this list to connect to sentinel. For high availability to be used you must have either defined; the host above or at least one node below. |
| configMap.session.redis.high_availability.password.disabled | bool | `false` | Disables this secret and leaves configuring it entirely up to you. |
| configMap.session.redis.high_availability.password.path | string | `"session.redis.sentinel.password.txt"` | The path to the secret. If it has a '/' prefix it's assumed to be an absolute path within the pod. Otherwise it uses the format '{mountPath}/{secret_name}/{path}' where '{mountPath}' refers to the 'secret.mountPath' value, '{secret_name}' is the secret_name above, and '{path}' is this value. |
| configMap.session.redis.high_availability.password.secret_name | string | `nil` | The secret name. The ~ name is special as it is the secret we generate either automatically or via the secret_value option below. |
| configMap.session.redis.high_availability.password.value | string | `""` | The value of a generated secret when using the ~ secret_name. |
| configMap.session.redis.high_availability.route_by_latency | bool | `false` | Choose the host with the lowest latency. |
| configMap.session.redis.high_availability.route_randomly | bool | `false` | Choose the host randomly. |
| configMap.session.redis.high_availability.sentinel_name | string | `"mysentinel"` | Sentinel Name / Master Name |
| configMap.session.redis.high_availability.username | string | `""` | The Redis Sentinel-specific username. If supplied, authentication will be done via Redis 6+ ACL-based authentication. If left blank, authentication to sentinels will be done via `requirepass`. |
| configMap.session.redis.host | string | `"redis.databases.svc.cluster.local"` | The redis host or unix socket path. If utilising an IPv6 literal address it must be enclosed by square brackets and quoted. |
| configMap.session.redis.maximum_active_connections | int | `8` | The maximum number of concurrent active connections to Redis. |
| configMap.session.redis.minimum_idle_connections | int | `0` | The target number of idle connections to have open ready for work. Useful when opening connections is slow. |
| configMap.session.redis.password.disabled | bool | `false` | Disables this secret and leaves configuring it entirely up to you. |
| configMap.session.redis.password.path | string | `"session.redis.password.txt"` | The path to the secret. If it has a '/' prefix it's assumed to be an absolute path within the pod. Otherwise it uses the format '{mountPath}/{secret_name}/{path}' where '{mountPath}' refers to the 'secret.mountPath' value, '{secret_name}' is the secret_name above, and '{path}' is this value. |
| configMap.session.redis.password.secret_name | string | `nil` | The secret name. The ~ name is special as it is the secret we generate either automatically or via the secret_value option below. |
| configMap.session.redis.password.value | string | `""` | The value of a generated secret when using the ~ secret_name. |
| configMap.session.redis.port | int | `6379` | The port redis is listening on. |
| configMap.session.redis.tls.enabled | bool | `false` | Enables rendering this TLS config. |
| configMap.session.redis.tls.maximum_version | string | `"TLS1.3"` | Maximum TLS version for the connection. |
| configMap.session.redis.tls.minimum_version | string | `"TLS1.2"` | Minimum TLS version for the connection. |
| configMap.session.redis.tls.server_name | string | `""` | The server subject name to check the servers certificate against during the validation process. This option is not required if the certificate has a SAN which matches the host option. |
| configMap.session.redis.tls.skip_verify | bool | `false` | Skip verifying the server certificate entirely. |
| configMap.session.redis.username | string | `""` | Optional username to be used with authentication. |
| configMap.session.remember_me | string | `"1 month"` | The remember me duration. |
| configMap.session.same_site | string | `"lax"` | Sets the Cookie SameSite value. Possible options are none, lax, or strict. Please read https://www.authelia.com/configuration/session/introduction/#same_site |
| configMap.storage.encryption_key.disabled | bool | `false` | Disables this secret and leaves configuring it entirely up to you. |
| configMap.storage.encryption_key.path | string | `"storage.encryption.key"` | The path to the secret. If it has a '/' prefix it's assumed to be an absolute path within the pod. Otherwise it uses the format '{mountPath}/{secret_name}/{path}' where '{mountPath}' refers to the 'secret.mountPath' value, '{secret_name}' is the secret_name above, and '{path}' is this value. |
| configMap.storage.encryption_key.secret_name | string | `nil` | The secret name. The ~ name is special as it is the secret we generate either automatically or via the secret_value option below. |
| configMap.storage.encryption_key.value | string | `""` | The value of a generated secret when using the ~ secret_name. |
| configMap.storage.local.enabled | bool | `false` | Enable the Local Provider (Storage / SQL) |
| configMap.storage.local.path | string | `"/config/db.sqlite3"` | Path to the SQLite3 database. |
| configMap.storage.mysql.address | string | `"tcp://mysql.databases.svc.cluster.local:3306"` | Configures the address for the MySQL/MariaDB Server. The address itself is a connector and the scheme must either be the unix scheme or one of the tcp schemes. |
| configMap.storage.mysql.database | string | `"authelia"` | The database name on the database server that the assigned user has access to for the purpose of Authelia. |
| configMap.storage.mysql.deploy | bool | `false` | Deploy the MySQL Chart. |
| configMap.storage.mysql.enabled | bool | `false` | Enable the MySQL Provider (Storage / SQL). |
| configMap.storage.mysql.password.disabled | bool | `false` | Disables this secret and leaves configuring it entirely up to you. |
| configMap.storage.mysql.password.path | string | `"storage.mysql.password.txt"` | The path to the secret. If it has a '/' prefix it's assumed to be an absolute path within the pod. Otherwise it uses the format '{mountPath}/{secret_name}/{path}' where '{mountPath}' refers to the 'secret.mountPath' value, '{secret_name}' is the secret_name above, and '{path}' is this value. |
| configMap.storage.mysql.password.secret_name | string | `nil` | The secret name. The ~ name is special as it is the secret we generate either automatically or via the secret_value option below. |
| configMap.storage.mysql.password.value | string | `""` | The value of a generated secret when using the ~ secret_name. |
| configMap.storage.mysql.timeout | string | `"5 seconds"` | The SQL connection timeout. |
| configMap.storage.mysql.tls.enabled | bool | `false` | Enables rendering this TLS config. |
| configMap.storage.mysql.tls.maximum_version | string | `"TLS1.3"` | Maximum TLS version for the connection. |
| configMap.storage.mysql.tls.minimum_version | string | `"TLS1.2"` | Minimum TLS version for the connection. |
| configMap.storage.mysql.tls.server_name | string | `""` | The server subject name to check the servers certificate against during the validation process. This option is not required if the certificate has a SAN which matches the host option. |
| configMap.storage.mysql.tls.skip_verify | bool | `false` | Skip verifying the server certificate entirely. |
| configMap.storage.mysql.username | string | `"authelia"` | The username paired with the password used to connect to the database. |
| configMap.storage.postgres.address | string | `"tcp://postgres.databases.svc.cluster.local:5432"` | Configures the address for the PostgreSQL Server. The address itself is a connector and the scheme must either be the unix scheme or one of the tcp schemes. |
| configMap.storage.postgres.database | string | `"authelia"` | The database name on the database server that the assigned user has access to for the purpose of Authelia. |
| configMap.storage.postgres.deploy | bool | `false` | Deploy the PostgreSQL Chart. |
| configMap.storage.postgres.enabled | bool | `false` | Enable the PostgreSQL Provider (Storage / SQL). |
| configMap.storage.postgres.password.disabled | bool | `false` | Disables this secret and leaves configuring it entirely up to you. |
| configMap.storage.postgres.password.path | string | `"storage.postgres.password.txt"` | The path to the secret. If it has a '/' prefix it's assumed to be an absolute path within the pod. Otherwise it uses the format '{mountPath}/{secret_name}/{path}' where '{mountPath}' refers to the 'secret.mountPath' value, '{secret_name}' is the secret_name above, and '{path}' is this value. |
| configMap.storage.postgres.password.secret_name | string | `nil` | The secret name. The ~ name is special as it is the secret we generate either automatically or via the secret_value option below. |
| configMap.storage.postgres.password.value | string | `""` | The value of a generated secret when using the ~ secret_name. |
| configMap.storage.postgres.schema | string | `"public"` | The database schema name to use on the database server that the assigned user has access to for the purpose of Authelia. By default this is the public schema. |
| configMap.storage.postgres.servers | list | `[]` | This specifies a list of additional fallback PostgreSQL instances to use should issues occur with the primary instance which is configured with the address and tls options. |
| configMap.storage.postgres.timeout | string | `"5 seconds"` | The SQL connection timeout. |
| configMap.storage.postgres.tls.enabled | bool | `false` | Enables rendering this TLS config. |
| configMap.storage.postgres.tls.maximum_version | string | `"TLS1.3"` | Maximum TLS version for the connection. |
| configMap.storage.postgres.tls.minimum_version | string | `"TLS1.2"` | Minimum TLS version for the connection. |
| configMap.storage.postgres.tls.server_name | string | `""` | The server subject name to check the servers certificate against during the validation process. This option is not required if the certificate has a SAN which matches the host option. |
| configMap.storage.postgres.tls.skip_verify | bool | `false` | Skip verifying the server certificate entirely. |
| configMap.storage.postgres.username | string | `"authelia"` | The username paired with the password used to connect to the database. |
| configMap.telemetry.metrics.buffers.read | int | `4096` | Read buffer. |
| configMap.telemetry.metrics.buffers.write | int | `4096` | Write buffer. |
| configMap.telemetry.metrics.enabled | bool | `false` | Enable Metrics. |
| configMap.telemetry.metrics.port | int | `9959` | The port to listen on for metrics. This should be on a different port to the main server.port value. |
| configMap.telemetry.metrics.serviceMonitor.annotations | object | `{}` | Extra annotations for the ServiceMonitor manifest. |
| configMap.telemetry.metrics.serviceMonitor.enabled | bool | `false` | Enable generating a Prometheus ServiceMonitor. |
| configMap.telemetry.metrics.serviceMonitor.labels | object | `{}` | Extra labels for the ServiceMonitor manifest. |
| configMap.telemetry.metrics.timeouts.idle | string | `"30 seconds"` | Idle timeout. |
| configMap.telemetry.metrics.timeouts.read | string | `"6 seconds"` | Read timeout. |
| configMap.telemetry.metrics.timeouts.write | string | `"6 seconds"` | Write timeout. |
| configMap.theme | string | `"light"` | Theme name to use for the frontend. |
| configMap.totp.algorithm | string | `"SHA1"` | The TOTP algorithm to use. It is CRITICAL you read the documentation before changing this option: https://www.authelia.com/configuration/second-factor/time-based-one-time-password/#algorithm |
| configMap.totp.allowed_algorithms | list | `["SHA1"]` | Similar to algorithm with the same restrictions except this option allows users to pick from this list. This list will always contain the value configured in the algorithm option. |
| configMap.totp.allowed_digits | list | `[6]` | Similar to digits with the same restrictions except this option allows users to pick from this list. This list will always contain the value configured in the digits option. |
| configMap.totp.allowed_periods | list | `[30]` | Similar to period with the same restrictions except this option allows users to pick from this list. This list will always contain the value configured in the period option. |
| configMap.totp.digits | int | `6` | The number of digits a user has to input. Must either be 6 or 8. Changing this option only affects newly generated TOTP configurations. It is CRITICAL you read the documentation before changing this option: https://www.authelia.com/configuration/second-factor/time-based-one-time-password/#digits |
| configMap.totp.disable | bool | `false` | Disable TOTP. |
| configMap.totp.issuer | string | `"Authelia"` | The issuer name displayed in the Authenticator application of your choice. Defaults to 'Authelia'. |
| configMap.totp.period | int | `30` | The period in seconds a one-time password is valid for. Changing this option only affects newly generated TOTP configurations. |
| configMap.totp.secret_size | int | `32` | The size of the generated shared secrets. Default is 32 and is sufficient in most use cases, minimum is 20. |
| configMap.totp.skew | int | `1` | The skew controls number of one-time passwords either side of the current one that are valid. Warning: before changing skew read the docs link below. See: https://www.authelia.com/configuration/second-factor/time-based-one-time-password/#input-validation to read the documentation. |
| configMap.webauthn.attestation_conveyance_preference | string | `"indirect"` | Conveyance preference controls if we collect the attestation statement including the AAGUID from the device. Options are none, indirect, direct. |
| configMap.webauthn.disable | bool | `false` | Disable Webauthn. |
| configMap.webauthn.display_name | string | `"Authelia"` | The display name the browser should show the user for when using Webauthn to login/register. |
| configMap.webauthn.filtering.permitted_aaguids | list | `[]` | A list of Authenticator Attestation GUID’s that are the only ones allowed to be registered. Useful if you have a company policy that requires certain authenticators. Mutually exclusive with prohibited_aaguids. |
| configMap.webauthn.filtering.prohibit_backup_eligibility | bool | `false` | Setting this value to true will ensure Authenticators which can export credentials will not be able to register. This will likely prevent synchronized credentials from being registered. |
| configMap.webauthn.filtering.prohibited_aaguids | list | `[]` | A list of Authenticator Attestation GUID’s that users will not be able to register. Useful if company policy prevents certain authenticators. Mutually exclusive with permitted_aaguids. |
| configMap.webauthn.metadata.enabled | bool | `false` | Enables metadata service validation of authenticators and credentials. This requires the download of the metadata service blob which will utilize about 5MB of data in your configured storage backend. |
| configMap.webauthn.metadata.validate_entry | bool | `true` | Enables validation that an entry exists for the authenticator in the MDS3 blob. It’s recommended that this option is the default value, however this may exclude some authenticators which DO NOT have FIDO compliance certification or have otherwise not registered with the MDS3. The recommendation is based on the fact that the authenticity of a particular authenticator cannot be validated without this. |
| configMap.webauthn.metadata.validate_entry_permit_zero_aaguid | bool | `false` | Allows authenticators which have provided an empty Authenticator Attestation GUID. This may be required for certain authenticators which DO NOT have FIDO compliance certification. |
| configMap.webauthn.metadata.validate_status | bool | `true` | Enables validation of the attestation entry statuses. There is generally never a reason to disable this as the authenticators excluded by default are likely compromised. |
| configMap.webauthn.metadata.validate_status_permitted | list | `[]` | A list of exclusively required statuses for an authenticator to pass validation. |
| configMap.webauthn.metadata.validate_status_prohibited | list | `[]` | A list of authenticator statuses which for an authenticator that are prohibited from being registered. |
| configMap.webauthn.metadata.validate_trust_anchor | bool | `true` | Enables validation of the attestation certificate against the Certificate Authority certificate in the validated MDS3 blob. It’s recommended this value is always the default value. |
| configMap.webauthn.selection_criteria.attachment | string | `""` | Sets the attachment preference for newly created credentials. |
| configMap.webauthn.selection_criteria.discoverability | string | `"preferred"` | Sets the discoverability preference. May affect the creation of Passkeys. |
| configMap.webauthn.selection_criteria.user_verification | string | `"preferred"` | Sets the user verification preference. |
| configMap.webauthn.timeout | string | `"60 seconds"` | Adjust the interaction timeout for Webauthn dialogues. |
| image.pullPolicy | string | `"IfNotPresent"` | The pull policy for the standard image. |
| image.pullSecrets | list | `[]` | The pull secrets to use. |
| image.registry | string | `"ghcr.io"` | The registry to use. |
| image.repository | string | `"authelia/authelia"` | The repository location on the registry. |
| image.tag | string | appVersion | The tag to use from the registry. |
| ingress.annotations | object | `{}` | Extra annotations for ingress related manifests. |
| ingress.certManager | bool | `false` | Enable Cert Manager annotations. |
| ingress.className | string | `""` | Ingress Class Name for the Ingress manifests. |
| ingress.enabled | bool | `false` | Enable generating ingress related resources. |
| ingress.gatewayAPI.enabled | bool | `false` | Enable Gateway API HTTP Route generation. |
| ingress.gatewayAPI.hostnamesOverride | list | `[]` | Override the hostnames for the HTTPRoute manifest. |
| ingress.gatewayAPI.parentRefs | list | `[]` | Configure the parent references for the HTTPRoute manifest. |
| ingress.labels | object | `{}` | Extra labels for ingress related manifests. |
| ingress.rulesOverride | list | `[]` | Override to the rules values for the Ingress type manifest. |
| ingress.tls.enabled | bool | `false` | Enable TLS for the Ingress. |
| ingress.tls.secret | string | `"authelia-tls"` |  |
| ingress.traefikCRD.apiGroupOverride | string | `""` | The apiGroupOverride overrides the first part of the apiVersion for TraefikCRD manifests. |
| ingress.traefikCRD.apiVersionOverride | string | `""` | The apiVersionOverride overrides the second part of the apiVersion for TraefikCRD manifests. |
| ingress.traefikCRD.disableIngressRoute | bool | `false` | Use a standard Ingress object, not an IngressRoute. |
| ingress.traefikCRD.enabled | bool | `false` | Enable generating the Traefik 3.x CRD Middleware etc manifests. |
| ingress.traefikCRD.entryPoints | list | `[]` | Defines the valid entryPoints to route for the IngressRoute. |
| ingress.traefikCRD.matchOverride | string | `""` | IngressRoute match rule override. |
| ingress.traefikCRD.middlewares.auth.authResponseHeaders | list | `["Remote-User","Remote-Name","Remote-Email","Remote-Groups"]` | Defines the ForwardAuth Middleware Auth Response Headers. |
| ingress.traefikCRD.middlewares.auth.endpointOverride | string | `""` | Overrides the endpoint used for the middleware. This is the portion of the endpoint after '/api/authz/'. |
| ingress.traefikCRD.middlewares.auth.nameOverride | string | `""` | Overrides the ForwardAuth Middleware (auth) name. |
| ingress.traefikCRD.middlewares.chains.auth.after | list | `[]` | List of Middlewares to apply after the forwardAuth Middleware in the authentication chain. |
| ingress.traefikCRD.middlewares.chains.auth.before | list | `[]` | List of Middlewares to apply before the forwardAuth Middleware in the authentication chain. |
| ingress.traefikCRD.middlewares.chains.auth.nameOverride | string | `""` | Overrides the Chain Middleware (auth) name. |
| ingress.traefikCRD.middlewares.chains.ingressRoute.after | list | `[]` | List of Middlewares to apply after the middleware in the IngressRoute chain. |
| ingress.traefikCRD.middlewares.chains.ingressRoute.before | list | `[]` | List of Middlewares to apply before the middleware in the IngressRoute chain. |
| ingress.traefikCRD.priority | int | `500` | Defines the rule priority for the IngressRoute. |
| ingress.traefikCRD.responseForwardingFlushInterval | string | `"100ms"` | Defines the Response Forwarding Flush Interval for the IngressRoute. |
| ingress.traefikCRD.sticky | bool | `false` | Defines the sticky value for the IngressRoute. |
| ingress.traefikCRD.stickyCookieNameOverride | string | `""` | Overrides the default sticky cookie name for the IngressRoute. |
| ingress.traefikCRD.strategy | string | `"RoundRobin"` | Defines the IngressRoute service strategy. |
| ingress.traefikCRD.tls.certResolver | string | `""` | Name of the Certificate Resolver to use. |
| ingress.traefikCRD.tls.disableTLSOptions | bool | `false` | Disables inclusion of the IngressRoute TLSOptions. |
| ingress.traefikCRD.tls.domainsOverride | list | `[]` | Override the domains values for TLS operations. |
| ingress.traefikCRD.tls.options.cipherSuites | list | `[]` | Override the default Cipher Suites. |
| ingress.traefikCRD.tls.options.curvePreferences | list | `[]` | Override the default Curve Preferences. |
| ingress.traefikCRD.tls.options.maxVersion | string | `"VersionTLS13"` | Maximum TLS Version. |
| ingress.traefikCRD.tls.options.minVersion | string | `"VersionTLS12"` | Minimum TLS Version. |
| ingress.traefikCRD.tls.options.nameOverride | string | `""` | Override the TLSOptions name. |
| ingress.traefikCRD.tls.options.sniStrict | bool | `false` | Require Strict SNI requirement. |
| ingress.traefikCRD.weight | int | `10` | Defines the service weight for the IngressRoute. |
| kubeDNSDomainOverride | string | `""` | Kubernetes DNS Domain Override allows forcibly overriding the default DNS Domain for Kubernetes 'cluster.local'. |
| kubeVersionOverride | string | `""` | Kubernetes Version Override allows forcibly overriding the detected KubeVersion for fallback capabilities assessment. The fallback capabilities assessment only occurs if the APIVersions Capabilities list does not include a known # APIVersion for a manifest which occurs with some CI/CD tooling. This value will completely override the value detected by helm. |
| labels | object | `{}` | Extra labels for all generated resources. Most manifest types have a more specific labels value associated with them. |
| mariadb | object | `{}` | Configure mariadb database subchart under this key. This will be deployed when storage.mysql.deploy is set to true Currently settings need to be manually copied from here to the storage.mysql section For more options and to see the @default please see [mariadb chart documentation](https://github.com/bitnami/charts/tree/main/bitnami/mariadb) |
| nameOverride | string | `nil` | The name override for this deployment. |
| networkPolicy.annotations | object | `{}` | Extra annotations for the NetworkPolicy manifest. |
| networkPolicy.enabled | bool | `false` | Enable the NetworkPolicy. |
| networkPolicy.ingress[0].from[0].namespaceSelector.matchLabels."authelia.com/network-policy" | string | `"namespace"` |  |
| networkPolicy.ingress[0].from[1].podSelector.matchLabels."authelia.com/network-policy" | string | `"pod"` |  |
| networkPolicy.ingress[0].ports[0].port | int | `9091` |  |
| networkPolicy.ingress[0].ports[0].protocol | string | `"TCP"` |  |
| networkPolicy.labels | object | `{}` | Extra labels for the NetworkPolicy manifest. |
| networkPolicy.policyTypes | list | `["Ingress"]` | The Policy Types such as Ingress or Egress. |
| persistence.accessModes | list | `["ReadWriteOnce"]` | PersistentVolumeClaim access modes. |
| persistence.annotations | object | `{}` | Extra annotations for the PersistentVolumeClaim related manifests. |
| persistence.enabled | bool | `false` | Enable the PersistentVolumeClaim features for Authelia. |
| persistence.existingClaim | string | `""` | Mounts an existing PersistentVolumeClaim. |
| persistence.labels | object | `{}` | Extra annotations for the PersistentVolumeClaim related manifests. |
| persistence.readOnly | bool | `false` | Mounts the PersistentVolumeClaim in read-only mode. |
| persistence.selector | object | `{}` |  |
| persistence.size | string | `"100Mi"` | PersistentVolumeClaim volume size. |
| persistence.storageClass | string | `""` | Uses the specified storageClass for the PersistentVolumeClaim. |
| persistence.subPath | string | `""` | Mounts specifically a subpath of the PersistentVolumeClaim. |
| persistence.volumeName | string | `""` | Persistent Volume Name. Useful if Persistent Volumes have been provisioned in advance and you want to use a specific one. |
| pod.annotations | object | `{}` | Extra annotations for the Pod spec. |
| pod.args | list | `[]` | Modifies the args for the command. Useful for debugging. |
| pod.autoscaling.annotations | object | `{}` | Extra annotations for the HorizontalPodAutoscaler manifest. |
| pod.autoscaling.behaviour.scaleDown.policies[0] | string | `{"periodSeconds":60,"type":null,"value":null}` | The scale down policy type. |
| pod.autoscaling.behaviour.scaleDown.policies[0].periodSeconds | int | `60` | The scale down policy period seconds. |
| pod.autoscaling.behaviour.scaleDown.policies[0].value | int | `nil` | The scale down policy value. |
| pod.autoscaling.behaviour.scaleDown.selectPolicy | string | `nil` | The select policy value. |
| pod.autoscaling.behaviour.scaleDown.stabilizationWindowSeconds | int | `nil` | The number of seconds to allow stabilization before scaling. |
| pod.autoscaling.behaviour.scaleDown.tolerance | int | `nil` | The amount of tolerance percentage. |
| pod.autoscaling.behaviour.scaleUp.policies[0] | string | `{"periodSeconds":60,"type":null,"value":null}` | The scale up policy type. |
| pod.autoscaling.behaviour.scaleUp.policies[0].periodSeconds | int | `60` | The scale down policy period seconds. |
| pod.autoscaling.behaviour.scaleUp.policies[0].value | int | `nil` | The scale up policy value. |
| pod.autoscaling.behaviour.scaleUp.selectPolicy | string | `nil` | The select policy value. |
| pod.autoscaling.behaviour.scaleUp.stabilizationWindowSeconds | int | `nil` | The number of seconds to allow stabilization before scaling. |
| pod.autoscaling.behaviour.scaleUp.tolerance | int | `nil` | The amount of tolerance percentage. |
| pod.autoscaling.enabled | bool | `false` | Enable the HorizontalPodAutoscaler which requires the in cluster metrics server. |
| pod.autoscaling.labels | object | `{}` | Extra labels for the HorizontalPodAutoscaler manifest. |
| pod.autoscaling.maxReplicas | int | `nil` | The maximum replicas for this policy. |
| pod.autoscaling.metrics[0] | string | `{"containerResource":{"container":null,"name":null,"target":{"averageUtilization":null,"averageValue":null,"type":null,"value":null}},"external":{"metric":{"name":null,"selector":{"matchExpressions":[],"matchLabels":{}}},"target":{"averageUtilization":null,"averageValue":null,"type":null,"value":null}},"object":{"describedObject":{"apiVersion":null,"kind":null,"name":null},"metric":{"name":null,"selector":{"matchExpressions":[],"matchLabels":{}}},"target":{"averageUtilization":null,"averageValue":null,"type":null,"value":null}},"pods":{"metric":{"name":null,"selector":{"matchExpressions":[],"matchLabels":{}}},"target":{"averageUtilization":null,"averageValue":null,"type":null,"value":null}},"resource":{"name":null,"target":{"averageUtilization":null,"averageValue":null,"type":null,"value":null}},"type":null}` | The type of metric to use for this rule. ContainerResource, External, Object, Pods, or Resource. |
| pod.autoscaling.metrics[0].containerResource.container | string | `nil` | Name of the container within the Pod. |
| pod.autoscaling.metrics[0].containerResource.name | string | `nil` | Name of resource. |
| pod.autoscaling.metrics[0].containerResource.target.averageUtilization | string | `nil` | Average Utilization value. |
| pod.autoscaling.metrics[0].containerResource.target.averageValue | string | `nil` | Average value. |
| pod.autoscaling.metrics[0].containerResource.target.type | string | `nil` | Represents the metric type. Utilization, Value, or AverageValue. |
| pod.autoscaling.metrics[0].containerResource.target.value | string | `nil` | Value. |
| pod.autoscaling.metrics[0].external.metric.name | string | `nil` | Name of the given metric. |
| pod.autoscaling.metrics[0].external.metric.selector.matchExpressions | list | `[]` | List of Match Expressions. |
| pod.autoscaling.metrics[0].external.metric.selector.matchLabels | object | `{}` | Dictionary of Match Labels. |
| pod.autoscaling.metrics[0].external.target.averageUtilization | string | `nil` | Average Utilization value. |
| pod.autoscaling.metrics[0].external.target.averageValue | string | `nil` | Average value. |
| pod.autoscaling.metrics[0].external.target.type | string | `nil` | Represents the metric type. Utilization, Value, or AverageValue. |
| pod.autoscaling.metrics[0].external.target.value | string | `nil` | Value. |
| pod.autoscaling.metrics[0].object.describedObject.apiVersion | string | `nil` | API Version of the referent. |
| pod.autoscaling.metrics[0].object.describedObject.kind | string | `nil` | Kind of the referent. |
| pod.autoscaling.metrics[0].object.describedObject.name | string | `nil` | Name of the referent. |
| pod.autoscaling.metrics[0].object.metric.name | string | `nil` | Name of the given metric. |
| pod.autoscaling.metrics[0].object.metric.selector.matchExpressions | list | `[]` | List of Match Expressions. |
| pod.autoscaling.metrics[0].object.metric.selector.matchLabels | object | `{}` | Dictionary of Match Labels. |
| pod.autoscaling.metrics[0].object.target.averageUtilization | string | `nil` | Average Utilization value. |
| pod.autoscaling.metrics[0].object.target.averageValue | string | `nil` | Average value. |
| pod.autoscaling.metrics[0].object.target.type | string | `nil` | Represents the metric type. Utilization, Value, or AverageValue. |
| pod.autoscaling.metrics[0].object.target.value | string | `nil` | Value. |
| pod.autoscaling.metrics[0].pods.metric.name | string | `nil` | Name of the given metric. |
| pod.autoscaling.metrics[0].pods.metric.selector.matchExpressions | list | `[]` | List of Match Expressions. |
| pod.autoscaling.metrics[0].pods.metric.selector.matchLabels | object | `{}` | Dictionary of Match Labels. |
| pod.autoscaling.metrics[0].pods.target.averageUtilization | string | `nil` | Average Utilization value. |
| pod.autoscaling.metrics[0].pods.target.averageValue | string | `nil` | Average value. |
| pod.autoscaling.metrics[0].pods.target.type | string | `nil` | Represents the metric type. Utilization, Value, or AverageValue. |
| pod.autoscaling.metrics[0].pods.target.value | string | `nil` | Value. |
| pod.autoscaling.metrics[0].resource.name | string | `nil` | Name of the resource. |
| pod.autoscaling.metrics[0].resource.target.averageUtilization | string | `nil` | Average Utilization value. |
| pod.autoscaling.metrics[0].resource.target.averageValue | string | `nil` | Average value. |
| pod.autoscaling.metrics[0].resource.target.type | string | `nil` | Represents the metric type. Utilization, Value, or AverageValue. |
| pod.autoscaling.metrics[0].resource.target.value | string | `nil` | Value. |
| pod.autoscaling.minReplicas | int | `nil` | The minimum replicas for this policy. |
| pod.command | list | `[]` | Modifies the command. Useful for debugging. |
| pod.disableRestartOnChanges | bool | `false` | Normally when a change is detected via helm install to something that only indirectly affects the pod, the pod will restart. This setting allows disabling this behaviour. |
| pod.env | list | `[]` | List of additional environment variables for the Pod. |
| pod.extraVolumeMounts | list | `[]` | Extra Volume Mounts. |
| pod.extraVolumes | list | `[]` | Extra Volumes. |
| pod.initContainers | list | `[]` | The list of custom initialization containers. |
| pod.kind | string | `"DaemonSet"` | The Pod Kind to use. Must be Deployment, DaemonSet, or StatefulSet. |
| pod.labels | object | `{}` | Extra labels for the Pod spec. |
| pod.priorityClassName | string | `""` | The priority class name for the Pod spec. |
| pod.probes.liveness.failureThreshold | int | `5` | Liveness Probe failure threshold. |
| pod.probes.liveness.initialDelaySeconds | int | `0` | Liveness Probe initial delay seconds. |
| pod.probes.liveness.periodSeconds | int | `30` | Liveness Probe period seconds. |
| pod.probes.liveness.successThreshold | int | `1` | Liveness Probe success threshold. |
| pod.probes.liveness.timeoutSeconds | int | `5` | Liveness Probe timeout seconds. |
| pod.probes.method.httpGet.path | string | `"/api/health"` | Adjusts the probe path. |
| pod.probes.method.httpGet.port | string | `"http"` | Adjusts the probe port. |
| pod.probes.method.httpGet.scheme | string | `"HTTP"` | Adjusts the probe scheme. |
| pod.probes.readiness.failureThreshold | int | `5` | Readiness Probe failure threshold. |
| pod.probes.readiness.initialDelaySeconds | int | `0` | Readiness Probe initial delay seconds. |
| pod.probes.readiness.periodSeconds | int | `5` | Readiness Probe period seconds. |
| pod.probes.readiness.successThreshold | int | `1` | Readiness Probe success threshold. |
| pod.probes.readiness.timeoutSeconds | int | `5` | Readiness Probe timeout seconds. |
| pod.probes.startup.failureThreshold | int | `6` | Startup Probe failure threshold. |
| pod.probes.startup.initialDelaySeconds | int | `10` | Startup Probe initial delay seconds. |
| pod.probes.startup.periodSeconds | int | `5` | Startup Probe period seconds. |
| pod.probes.startup.successThreshold | int | `1` | Startup Probe success threshold. |
| pod.probes.startup.timeoutSeconds | int | `5` | Startup Probe timeout seconds. |
| pod.replicas | int | `1` | The number of replicas if relevant. |
| pod.resources.limits | object | `{}` | Resource Limits. |
| pod.resources.requests | object | `{}` | Resource Requests. |
| pod.revisionHistoryLimit | int | `5` | The revision history limit. |
| pod.securityContext.container | object | `{}` | Container Security Context. |
| pod.securityContext.pod | object | `{}` | Pod Security Context. |
| pod.selectors.affinity.nodeAffinity | object | `{}` | Node affinity selector. |
| pod.selectors.affinity.podAffinity | object | `{}` | Pod affinity selector. |
| pod.selectors.affinity.podAntiAffinity | object | `{}` | Pod anti-affinity selector. |
| pod.selectors.nodeName | string | `""` | Specific node name selector. |
| pod.selectors.nodeSelector | object | `{}` | Node selector. |
| pod.strategy.rollingUpdate.maxSurge | string | `"25%"` | RollingUpdate max surge value. |
| pod.strategy.rollingUpdate.maxUnavailable | string | `"25%"` | RollingUpdate max unavailable value. |
| pod.strategy.rollingUpdate.partition | int | `0` | RollingUpdate partition value. |
| pod.strategy.type | string | `"RollingUpdate"` | Deployment Strategy Type. |
| pod.tolerations | list | `[]` | List of tolerations. |
| podDisruptionBudget.annotations | object | `{}` | Extra annotations for the PodDisruptionBudget manifest. |
| podDisruptionBudget.enabled | bool | `false` | Enable the PodDisruptionBudget. |
| podDisruptionBudget.labels | object | `{}` | Extra labels for the PodDisruptionBudget manifest. |
| podDisruptionBudget.maxUnavailable | int | `0` | Maximum available value for the PodDisruptionBudget manifest. |
| podDisruptionBudget.minAvailable | int | `0` | Minimum available value for the PodDisruptionBudget manifest. |
| postgresql | object | `{}` | Configure postgresql database subchart under this key. This will be deployed when storage.postgres.deploy is set to true Currently settings need to be manually copied from here to the storage.postgres section For more options and to see the @default please see [postgresql chart documentation](https://github.com/bitnami/charts/tree/main/bitnami/postgresql) |
| rbac.annotations | object | `{}` | Extra annotations for RBAC related manifests. |
| rbac.enabled | bool | `false` | Enable RBAC. Turning this on associates Authelia with a service account. |
| rbac.labels | object | `{}` | Extra labels for RBAC related manifests. |
| rbac.serviceAccountName | string | `"authelia"` | Kubernetes service account name to generate. |
| redis | object | `{}` | Configure redis database subchart under this key. This will be deployed when session.redis.deploy is set to true Currently settings need to be manually copied from here to the session.redis section For more options and to see the @default please see [redis chart documentation](https://github.com/bitnami/charts/tree/main/bitnami/redis) |
| secret.additionalSecrets | object | `{}` | Additional secrets to mount to the Pod. |
| secret.annotations | object | `{}` | Extra annotations for the Secret manifest. |
| secret.disabled | bool | `false` | Disable the Secret manifest functionality. |
| secret.existingSecret | string | `""` | Name of an existing Secret manifest to mount instead of generating one. |
| secret.labels | object | `{}` | Extra labels for the Secret manifest. |
| secret.mountPath | string | `"/secrets"` | Pod path to mount the values of the Secret manifest. |
| service.annotations | object | `{}` | Extra annotations for service manifest. |
| service.clusterIP | string | `"10.0.0.1"` | Cluster IP for the Authelia service manifest. |
| service.labels | object | `{}` | Extra labels for service manifest. |
| service.nodePort | int | `30091` | Node Port for the Authelia service manifest. |
| service.port | int | `80` | Port for the Authelia service manifest. |
| service.type | string | `"ClusterIP"` | The service type to generate for the Authelia pods. |
| versionOverride | string | `""` | Version Override allows changing some chart characteristics that render only on specific versions. This does NOT affect the image used, please see the below image section instead for this. If this value is not specified, it's assumed the appVersion of the chart is the version. The format of this value  is x.x.x, for example 4.100.0. Minimum value is 4.38.0, and support is not guaranteed. |

