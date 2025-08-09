# authelia

![Version: 0.10.41](https://img.shields.io/badge/Version-0.10.41-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 4.39.6](https://img.shields.io/badge/AppVersion-4.39.6-informational?style=flat-square)

Authelia is a Single Sign-On Multi-Factor portal for web apps

**Homepage:** <https://www.authelia.com>

## ⚠️ Development Status

**This chart is in early development (pre-1.0).** For this chart we use 0.major.minor semantic versioning, which means:
- **No stability guarantees** - Anything may change in any release including a breaking change
- **API may change without notice** - Chart structure and values can change significantly
- **It may not be suitable for production use** - Use at your own risk, and additional caution is recommended
- **Always pin to specific versions** - Avoid version ranges to prevent unexpected breaking changes during updates

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

### Expected Minimum Configuration

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

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| james-d-elliott | <james-d-elliott@users.noreply.github.com> | <https://github.com/james-d-elliott> |

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

<table>
	<thead>
		<th>Key</th>
		<th>Type</th>
		<th>Default</th>
		<th>Description</th>
	</thead>
	<tbody>
		<tr>
			<td>annotations</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Extra annotations for all generated resources. Most manifest types have a more specific annotations value associated with them.</td>
		</tr>
		<tr>
			<td>appNameOverride</td>
			<td>string</td>
			<td><pre lang="json">
null
</pre>
</td>
			<td>The app name override for this deployment.</td>
		</tr>
		<tr>
			<td>certificates.annotations</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Extra annotations for the Certificates Secret manifest.</td>
		</tr>
		<tr>
			<td>certificates.existingSecret</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>Name of an existing Secret manifest to mount which contains trusted certificates.</td>
		</tr>
		<tr>
			<td>certificates.labels</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Extra labels for the Certificates Secret manifest.</td>
		</tr>
		<tr>
			<td>certificates.values</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td>List of secret name value pairs to include in this Secret manifest.</td>
		</tr>
		<tr>
			<td>configMap.access_control.default_policy</td>
			<td>string</td>
			<td><pre lang="json">
"deny"
</pre>
</td>
			<td>Default policy can either be 'bypass', 'one_factor', 'two_factor' or 'deny'. It is the policy applied to any resource if there is no policy to be applied to the user.</td>
		</tr>
		<tr>
			<td>configMap.access_control.rules</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td>Access Control Rule list.</td>
		</tr>
		<tr>
			<td>configMap.access_control.secret.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Enables the ACL section being generated as a secret.</td>
		</tr>
		<tr>
			<td>configMap.access_control.secret.existingSecret</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>An existingSecret name, if configured this will force the secret to be mounted using the key above.</td>
		</tr>
		<tr>
			<td>configMap.access_control.secret.key</td>
			<td>string</td>
			<td><pre lang="json">
"configuration.acl.yaml"
</pre>
</td>
			<td>The key in the secret which contains the file to mount.</td>
		</tr>
		<tr>
			<td>configMap.annotations</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Extra annotations for the ConfigMap manifest.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.file.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Enable File Backend (Authentication).</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.file.extra_attributes</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>The extra attributes to load from the directory server. These extra attributes can be used in other areas of Authelia such as OpenID Connect 1.0. It’s also recommended to check out the Attributes Reference Guide for more information.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.file.password.algorithm</td>
			<td>string</td>
			<td><pre lang="json">
"argon2"
</pre>
</td>
			<td>Controls the hashing algorithm used for hashing new passwords.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.file.password.argon2.iterations</td>
			<td>int</td>
			<td><pre lang="json">
3
</pre>
</td>
			<td>Controls the number of iterations when hashing passwords using Argon2.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.file.password.argon2.key_length</td>
			<td>int</td>
			<td><pre lang="json">
32
</pre>
</td>
			<td>Controls the output key length when hashing passwords using Argon2.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.file.password.argon2.memory</td>
			<td>int</td>
			<td><pre lang="json">
65536
</pre>
</td>
			<td>Controls the amount of memory in kibibytes when hashing passwords using Argon2.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.file.password.argon2.parallelism</td>
			<td>int</td>
			<td><pre lang="json">
4
</pre>
</td>
			<td>Controls the parallelism factor when hashing passwords using Argon2.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.file.password.argon2.salt_length</td>
			<td>int</td>
			<td><pre lang="json">
16
</pre>
</td>
			<td>Controls the output salt length when hashing passwords using Argon2</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.file.password.argon2.variant</td>
			<td>string</td>
			<td><pre lang="json">
"argon2id"
</pre>
</td>
			<td>Controls the variant when hashing passwords using Argon2. Recommended argon2id. Permitted values argon2id, argon2i, argon2d.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.file.password.bcrypt.cost</td>
			<td>int</td>
			<td><pre lang="json">
12
</pre>
</td>
			<td>Controls the hashing cost when hashing passwords using Bcrypt.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.file.password.bcrypt.variant</td>
			<td>string</td>
			<td><pre lang="json">
"standard"
</pre>
</td>
			<td>Controls the variant when hashing passwords using Bcrypt. Recommended standard. Permitted values standard, sha256.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.file.password.pbkdf2.iterations</td>
			<td>int</td>
			<td><pre lang="json">
310000
</pre>
</td>
			<td>Controls the number of iterations when hashing passwords using PBKDF2.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.file.password.pbkdf2.salt_length</td>
			<td>int</td>
			<td><pre lang="json">
16
</pre>
</td>
			<td>Controls the output salt length when hashing passwords using PBKDF2.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.file.password.pbkdf2.variant</td>
			<td>string</td>
			<td><pre lang="json">
"sha512"
</pre>
</td>
			<td>Controls the variant when hashing passwords using PBKDF2. Recommended sha512. Permitted values sha1, sha224, sha256, sha384, sha512.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.file.password.scrypt.block_size</td>
			<td>int</td>
			<td><pre lang="json">
8
</pre>
</td>
			<td>Controls the block size when hashing passwords using Scrypt.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.file.password.scrypt.iterations</td>
			<td>int</td>
			<td><pre lang="json">
16
</pre>
</td>
			<td>Controls the number of iterations when hashing passwords using Scrypt.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.file.password.scrypt.key_length</td>
			<td>int</td>
			<td><pre lang="json">
32
</pre>
</td>
			<td>Controls the output key length when hashing passwords using Scrypt.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.file.password.scrypt.parallelism</td>
			<td>int</td>
			<td><pre lang="json">
1
</pre>
</td>
			<td>Controls the parallelism factor when hashing passwords using Scrypt.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.file.password.scrypt.salt_length</td>
			<td>int</td>
			<td><pre lang="json">
16
</pre>
</td>
			<td>Controls the output salt length when hashing passwords using Scrypt.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.file.password.scrypt.variant</td>
			<td>string</td>
			<td><pre lang="json">
"scrypt"
</pre>
</td>
			<td>Controls the variant when hashing passwords using Scrypt. Permitted values scrypt, yescrypt.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.file.password.sha2crypt.iterations</td>
			<td>int</td>
			<td><pre lang="json">
50000
</pre>
</td>
			<td>Controls the number of iterations when hashing passwords using SHA2 Crypt.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.file.password.sha2crypt.salt_length</td>
			<td>int</td>
			<td><pre lang="json">
16
</pre>
</td>
			<td>Controls the output salt length when hashing passwords using SHA2 Crypt.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.file.password.sha2crypt.variant</td>
			<td>string</td>
			<td><pre lang="json">
"sha512"
</pre>
</td>
			<td>Controls the variant when hashing passwords using SHA2 Crypt. Recommended sha512. Permitted values sha256, sha512.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.file.path</td>
			<td>string</td>
			<td><pre lang="json">
"/config/users_database.yml"
</pre>
</td>
			<td>The path to the file with the user details list.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.file.search.case_insensitive</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Enabling this search option allows users to login with their username regardless of case. If enabled users must only have lowercase usernames.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.file.search.email</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Allows users to login using their email address. If enabled two users must not have the same emails and their usernames must not be an email.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.file.watch</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Enables reloading the database by watching it for changes.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.ldap.additional_groups_dn</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>An additional dn to define the scope of groups.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.ldap.additional_users_dn</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>An additional dn to define the scope to all users.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.ldap.address</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>The address for the ldap server. Format: <scheme>://<address>[:<port>]. Scheme can be ldap or ldaps in the format (port optional).</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.ldap.attributes.birthdate</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>The attribute holding the birthdate of the user.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.ldap.attributes.country</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>The attribute holding the country of the user.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.ldap.attributes.display_name</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>The attribute holding the display name of the user. This will be used to greet an authenticated user.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.ldap.attributes.distinguished_name</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>The attribute holding the distinguished name of the user.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.ldap.attributes.extra</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>The extra attributes for users.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.ldap.attributes.family_name</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>The attribute holding the family name of the user.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.ldap.attributes.gender</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>The attribute holding the gender of the user.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.ldap.attributes.given_name</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>The attribute holding the given name of the user.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.ldap.attributes.group_name</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>The attribute holding the name of the group.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.ldap.attributes.locale</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>The attribute holding the locale of the user.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.ldap.attributes.locality</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>The attribute holding the locality of the user.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.ldap.attributes.mail</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>The attribute holding the mail address of the user. If multiple email addresses are defined for a user, only the first one returned by the LDAP server is used.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.ldap.attributes.member_of</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>The attribute which represents the objects this user is a member of.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.ldap.attributes.middle_name</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>The attribute holding the middle name of the user.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.ldap.attributes.nickname</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>The attribute holding the nickname of the user.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.ldap.attributes.phone_extension</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>The attribute holding the phone extension of the user.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.ldap.attributes.phone_number</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>The attribute holding the phone number of the user.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.ldap.attributes.picture</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>The attribute holding the picture URL of the user.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.ldap.attributes.postal_code</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>The attribute holding the postal code of the user.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.ldap.attributes.profile</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>The attribute holding the profile of the user.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.ldap.attributes.region</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>The attribute holding the region of the user.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.ldap.attributes.street_address</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>The attribute holding the street address of the user.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.ldap.attributes.username</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>The attribute holding the username of the user. This attribute is used to populate the username in the session information.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.ldap.attributes.website</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>The attribute holding the website of the user.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.ldap.attributes.zoneinfo</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>The attribute holding the zoneinfo of the user.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.ldap.base_dn</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>The base dn for every LDAP query.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.ldap.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Enable LDAP Backend.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.ldap.groups_filter</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>The groups filter used in search queries to find the groups of the user.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.ldap.implementation</td>
			<td>string</td>
			<td><pre lang="json">
"activedirectory"
</pre>
</td>
			<td>The LDAP implementation, this affects elements like the attribute utilised for resetting a password.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.ldap.password.disabled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Disables this secret and leaves configuring it entirely up to you.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.ldap.password.path</td>
			<td>string</td>
			<td><pre lang="json">
"authentication.ldap.password.txt"
</pre>
</td>
			<td>The path to the secret. If it has a '/' prefix it's assumed to be an absolute path within the pod. Otherwise it uses the format '{mountPath}/{secret_name}/{path}' where '{mountPath}' refers to the 'secret.mountPath' value, '{secret_name}' is the secret_name above, and '{path}' is this value.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.ldap.password.secret_name</td>
			<td>string</td>
			<td><pre lang="json">
null
</pre>
</td>
			<td>The secret name. The ~ name is special as it is the secret we generate either automatically or via the secret_value option below.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.ldap.password.value</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>The value of a generated secret when using the ~ secret_name.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.ldap.permit_feature_detection_failure</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>This option is strongly discouraged. If enabled it will ignore errors looking up the RootDSE for supported controls/extensions.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.ldap.permit_referrals</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Follow referrals returned by the server. This is especially useful for environments where read-only servers exist. Only implemented for write operations.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.ldap.permit_unauthenticated_bind</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Permits use of an unauthenticated bind. WARNING: This option is strongly discouraged. Please consider disabling unauthenticated binding to your LDAP server and utilizing a service account.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.ldap.pooling.count</td>
			<td>int</td>
			<td><pre lang="json">
5
</pre>
</td>
			<td>The number of open connections to be available in the pool at any given time.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.ldap.pooling.enable</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Enables the connection pooling functionality.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.ldap.pooling.retries</td>
			<td>int</td>
			<td><pre lang="json">
2
</pre>
</td>
			<td>The number of attempts to obtain a free connecting that are made within the timeout period. This effectively splits the timeout into chunks.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.ldap.pooling.timeout</td>
			<td>string</td>
			<td><pre lang="json">
"10 seconds"
</pre>
</td>
			<td>The amount of time that we wait for a connection to become free in the pool before giving up and failing with an error.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.ldap.start_tls</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Use StartTLS with the LDAP connection.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.ldap.timeout</td>
			<td>string</td>
			<td><pre lang="json">
"5 seconds"
</pre>
</td>
			<td>Connection Timeout.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.ldap.tls.maximum_version</td>
			<td>string</td>
			<td><pre lang="json">
"TLS1.3"
</pre>
</td>
			<td>Maximum TLS version for the connection.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.ldap.tls.minimum_version</td>
			<td>string</td>
			<td><pre lang="json">
"TLS1.2"
</pre>
</td>
			<td>Minimum TLS version for the connection.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.ldap.tls.server_name</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>The server subject name to check the servers certificate against during the validation process. This option is not required if the certificate has a SAN which matches the host portion of the url option.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.ldap.tls.skip_verify</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Skip verifying the server certificate entirely.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.ldap.user</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>The username of the admin user.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.ldap.users_filter</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>The users filter used in search queries to find the user profile based on input filled in login form.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.password_change.disable</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Disable both the HTML element and the API for change password functionality.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.password_reset.custom_url</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>External reset password url that redirects the user to an external reset portal. This disables the internal reset functionality.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.password_reset.disable</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Disable both the HTML element and the API for reset password functionality.</td>
		</tr>
		<tr>
			<td>configMap.authentication_backend.refresh_interval</td>
			<td>string</td>
			<td><pre lang="json">
"5 minutes"
</pre>
</td>
			<td>The amount of time to wait before we refresh data from the authentication backend. Uses duration notation.</td>
		</tr>
		<tr>
			<td>configMap.default_2fa_method</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>Set the default 2FA method for new users and for when a user has a preferred method configured that has been disabled. This setting must be a method that is enabled. Options are totp, webauthn, mobile_push.</td>
		</tr>
		<tr>
			<td>configMap.definitions.network</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>The network section configures named network lists.</td>
		</tr>
		<tr>
			<td>configMap.definitions.user_attributes</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>The user attributes section allows you to define custom attributes for your users using Common Expression Language (CEL).</td>
		</tr>
		<tr>
			<td>configMap.disabled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Disable the configMap source for the Authelia config. If this is false you need to provide a volumeMount via PV/PVC or other means that mounts to /config.</td>
		</tr>
		<tr>
			<td>configMap.duo_api.enable_self_enrollment</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Enables Duo device self-enrollment from within the Authelia portal.</td>
		</tr>
		<tr>
			<td>configMap.duo_api.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Enables Duo.</td>
		</tr>
		<tr>
			<td>configMap.duo_api.hostname</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>The Duo API hostname. This is provided in the Duo dashboard.</td>
		</tr>
		<tr>
			<td>configMap.duo_api.integration_key</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>The non-secret Duo integration key. Similar to a client identifier. This is provided in the Duo dashboard.</td>
		</tr>
		<tr>
			<td>configMap.duo_api.secret.disabled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Disables this secret and leaves configuring it entirely up to you.</td>
		</tr>
		<tr>
			<td>configMap.duo_api.secret.path</td>
			<td>string</td>
			<td><pre lang="json">
"duo.key"
</pre>
</td>
			<td>The path to the secret. If it has a '/' prefix it's assumed to be an absolute path within the pod. Otherwise it uses the format '{mountPath}/{secret_name}/{path}' where '{mountPath}' refers to the 'secret.mountPath' value, '{secret_name}' is the secret_name above, and '{path}' is this value.</td>
		</tr>
		<tr>
			<td>configMap.duo_api.secret.secret_name</td>
			<td>string</td>
			<td><pre lang="json">
null
</pre>
</td>
			<td>The secret name. The ~ name is special as it is the secret we generate either automatically or via the secret_value option below.</td>
		</tr>
		<tr>
			<td>configMap.duo_api.secret.value</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>The value of a generated secret when using the ~ secret_name.</td>
		</tr>
		<tr>
			<td>configMap.existingConfigMap</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>The name of an existing ConfigMap instead of generating one.</td>
		</tr>
		<tr>
			<td>configMap.extraConfigs</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td>The paths of extra configs that are mounted into the Pod which should be used.</td>
		</tr>
		<tr>
			<td>configMap.filters.disabled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Disables the template filters. This is not recommended.</td>
		</tr>
		<tr>
			<td>configMap.identity_providers.oidc.authorization_policies</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Authorization Policies configuration.</td>
		</tr>
		<tr>
			<td>configMap.identity_providers.oidc.claims_policies</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>The claims policies are policies which allow customizing the behavior of claims and the available claims for a particular client.</td>
		</tr>
		<tr>
			<td>configMap.identity_providers.oidc.clients</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td>List of registered clients for this provider.</td>
		</tr>
		<tr>
			<td>configMap.identity_providers.oidc.cors.allowed_origins</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td>List of allowed origins. Any origin with https is permitted unless this option is configured or the allowed_origins_from_client_redirect_uris option is enabled.</td>
		</tr>
		<tr>
			<td>configMap.identity_providers.oidc.cors.allowed_origins_from_client_redirect_uris</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Automatically adds the origin portion of all redirect URI's on all clients to the list of allowed_origins, provided they have the scheme http or https and do not have the hostname of localhost.</td>
		</tr>
		<tr>
			<td>configMap.identity_providers.oidc.cors.endpoints</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td>List of endpoints in addition to the metadata endpoints to permit cross-origin requests on.</td>
		</tr>
		<tr>
			<td>configMap.identity_providers.oidc.enable_client_debug_messages</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Enables additional debug messages. SECURITY NOTICE: It's not recommended to use this in production as it may leak configuration information to clients.</td>
		</tr>
		<tr>
			<td>configMap.identity_providers.oidc.enable_pkce_plain_challenge</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Enables the plain PKCE challenge which is not recommended for security reasons but may be necessary for some clients.</td>
		</tr>
		<tr>
			<td>configMap.identity_providers.oidc.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Enables this in the config map. Currently in beta stage. See https://www.authelia.com/r/openid-connect/</td>
		</tr>
		<tr>
			<td>configMap.identity_providers.oidc.enforce_pkce</td>
			<td>string</td>
			<td><pre lang="json">
"public_clients_only"
</pre>
</td>
			<td>Adjusts the PKCE enforcement. Options are always, public_clients_only, never. For security reasons it's recommended this option is public_clients_only or always, however always is not compatible with all clients.</td>
		</tr>
		<tr>
			<td>configMap.identity_providers.oidc.hmac_secret.disabled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Disables this secret and leaves configuring it entirely up to you.</td>
		</tr>
		<tr>
			<td>configMap.identity_providers.oidc.hmac_secret.path</td>
			<td>string</td>
			<td><pre lang="json">
"identity_providers.oidc.hmac.key"
</pre>
</td>
			<td>The path to the secret. If it has a '/' prefix it's assumed to be an absolute path within the pod. Otherwise it uses the format '{mountPath}/{secret_name}/{path}' where '{mountPath}' refers to the 'secret.mountPath' value, '{secret_name}' is the secret_name above, and '{path}' is this value.</td>
		</tr>
		<tr>
			<td>configMap.identity_providers.oidc.hmac_secret.secret_name</td>
			<td>string</td>
			<td><pre lang="json">
null
</pre>
</td>
			<td>The secret name. The ~ name is special as it is the secret we generate either automatically or via the secret_value option below.</td>
		</tr>
		<tr>
			<td>configMap.identity_providers.oidc.hmac_secret.value</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>The value of a generated secret when using the ~ secret_name.</td>
		</tr>
		<tr>
			<td>configMap.identity_providers.oidc.jwks</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td>The JWK's issuer option configures multiple JSON Web Keys. It's required that at least one of the JWK's configured has the RS256 algorithm. For RSA keys (RS or PS) the minimum is a 2048 bit key.</td>
		</tr>
		<tr>
			<td>configMap.identity_providers.oidc.lifespans.access_token</td>
			<td>string</td>
			<td><pre lang="json">
"1 hour"
</pre>
</td>
			<td>Default lifespan for Access Tokens.</td>
		</tr>
		<tr>
			<td>configMap.identity_providers.oidc.lifespans.authorize_code</td>
			<td>string</td>
			<td><pre lang="json">
"1 minute"
</pre>
</td>
			<td>Default lifespan for Authorize Codes.</td>
		</tr>
		<tr>
			<td>configMap.identity_providers.oidc.lifespans.custom</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>The custom lifespan configuration allows customizing the lifespans per-client. The custom lifespans must be utilized with the client lifespan option which applies those settings to that client. Custom lifespans can be configured in a very granular way, either solely by the token type, or by the token type for each grant type.</td>
		</tr>
		<tr>
			<td>configMap.identity_providers.oidc.lifespans.device_code</td>
			<td>string</td>
			<td><pre lang="json">
"10 minutes"
</pre>
</td>
			<td>Default lifespan for Device Codes.</td>
		</tr>
		<tr>
			<td>configMap.identity_providers.oidc.lifespans.id_token</td>
			<td>string</td>
			<td><pre lang="json">
"1 hour"
</pre>
</td>
			<td>Default lifespan for ID Tokens.</td>
		</tr>
		<tr>
			<td>configMap.identity_providers.oidc.lifespans.refresh_token</td>
			<td>string</td>
			<td><pre lang="json">
"1 hour and 30 minutes"
</pre>
</td>
			<td>Default lifespan for Refresh Tokens.</td>
		</tr>
		<tr>
			<td>configMap.identity_providers.oidc.minimum_parameter_entropy</td>
			<td>int</td>
			<td><pre lang="json">
8
</pre>
</td>
			<td>Adjusts the parameter entropy requirements for nonce/state etc. SECURITY NOTICE: It's not recommended changing this option, and highly discouraged to have it less than 8.</td>
		</tr>
		<tr>
			<td>configMap.identity_providers.oidc.pushed_authorizations.context_lifespan</td>
			<td>string</td>
			<td><pre lang="json">
"5 minutes"
</pre>
</td>
			<td>Adjusts the lifespan for a Pushed Authorization session / context.</td>
		</tr>
		<tr>
			<td>configMap.identity_providers.oidc.pushed_authorizations.enforce</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Requires Pushed Authorization Requests for all Authorization Flows.</td>
		</tr>
		<tr>
			<td>configMap.identity_providers.oidc.scopes</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>A list of scope definitions available in addition to the standard ones.</td>
		</tr>
		<tr>
			<td>configMap.identity_validation.elevated_session.characters</td>
			<td>int</td>
			<td><pre lang="json">
8
</pre>
</td>
			<td>The number of characters the random One-Time Code has. Maximum value is currently 20, but we recommend keeping it between 8 and 12. It’s strongly discouraged to reduce it below 8.</td>
		</tr>
		<tr>
			<td>configMap.identity_validation.elevated_session.code_lifespan</td>
			<td>string</td>
			<td><pre lang="json">
"5 minutes"
</pre>
</td>
			<td>The lifespan of the randomly generated One Time Code after which it’s considered invalid.</td>
		</tr>
		<tr>
			<td>configMap.identity_validation.elevated_session.elevation_lifespan</td>
			<td>string</td>
			<td><pre lang="json">
"10 minutes"
</pre>
</td>
			<td>The lifespan of the elevation after initially validating the One-Time Code before it expires.</td>
		</tr>
		<tr>
			<td>configMap.identity_validation.elevated_session.require_second_factor</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Requires second factor authentication for all protected actions in addition to the elevated session provided the user has configured a second factor authentication method.</td>
		</tr>
		<tr>
			<td>configMap.identity_validation.elevated_session.skip_second_factor</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Skips the elevated session requirement if the user has performed second factor authentication. Can be combined with the require_second_factor option to always (and only) require second factor authentication.</td>
		</tr>
		<tr>
			<td>configMap.identity_validation.reset_password.jwt_algorithm</td>
			<td>string</td>
			<td><pre lang="json">
"HS256"
</pre>
</td>
			<td>The JSON Web Token Algorithm used to sign the JWT. Must be HS256, HS384, or HS512.</td>
		</tr>
		<tr>
			<td>configMap.identity_validation.reset_password.jwt_lifespan</td>
			<td>string</td>
			<td><pre lang="json">
"5 minutes"
</pre>
</td>
			<td>The lifespan of the JSON Web Token after it’s initially generated after which it’s considered invalid.</td>
		</tr>
		<tr>
			<td>configMap.identity_validation.reset_password.secret.disabled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Disables this secret and leaves configuring it entirely up to you.</td>
		</tr>
		<tr>
			<td>configMap.identity_validation.reset_password.secret.path</td>
			<td>string</td>
			<td><pre lang="json">
"identity_validation.reset_password.jwt.hmac.key"
</pre>
</td>
			<td>The path to the secret. If it has a '/' prefix it's assumed to be an absolute path within the pod. Otherwise it uses the format '{mountPath}/{secret_name}/{path}' where '{mountPath}' refers to the 'secret.mountPath' value, '{secret_name}' is the secret_name above, and '{path}' is this value.</td>
		</tr>
		<tr>
			<td>configMap.identity_validation.reset_password.secret.secret_name</td>
			<td>string</td>
			<td><pre lang="json">
null
</pre>
</td>
			<td>The secret name. The ~ name is special as it is the secret we generate either automatically or via the secret_value option below.</td>
		</tr>
		<tr>
			<td>configMap.identity_validation.reset_password.secret.value</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>The value of a generated secret when using the ~ secret_name.</td>
		</tr>
		<tr>
			<td>configMap.key</td>
			<td>string</td>
			<td><pre lang="json">
"configuration.yaml"
</pre>
</td>
			<td>The key from the ConfigMap manifest to generate and mount the configuration.</td>
		</tr>
		<tr>
			<td>configMap.labels</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Extra labels for the ConfigMap manifest.</td>
		</tr>
		<tr>
			<td>configMap.log.file_path</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>File path where the logs will be written. If not set logs are written to stdout.</td>
		</tr>
		<tr>
			<td>configMap.log.format</td>
			<td>string</td>
			<td><pre lang="json">
"text"
</pre>
</td>
			<td>Format the logs are written as: json, text.</td>
		</tr>
		<tr>
			<td>configMap.log.level</td>
			<td>string</td>
			<td><pre lang="json">
"info"
</pre>
</td>
			<td>Level of verbosity for logs: info, debug, trace.</td>
		</tr>
		<tr>
			<td>configMap.notifier.disable_startup_check</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>You can disable the notifier startup check by setting this to true.</td>
		</tr>
		<tr>
			<td>configMap.notifier.filesystem.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Enables the File System Provider (Notifier).</td>
		</tr>
		<tr>
			<td>configMap.notifier.filesystem.filename</td>
			<td>string</td>
			<td><pre lang="json">
"/config/notification.txt"
</pre>
</td>
			<td>The file to add email text to. If it doesn’t exist it will be created.</td>
		</tr>
		<tr>
			<td>configMap.notifier.smtp.address</td>
			<td>string</td>
			<td><pre lang="json">
"submission://smtp.mail.svc.cluster.local:587"
</pre>
</td>
			<td>Configures the address for the SMTP Server. The address itself is a connector and the scheme must be smtp, submission, or submissions. The only difference between these schemes are the default ports and submissions requires a TLS transport per SMTP Ports Security Measures, whereas submission and smtp use a standard TCP transport and typically enforce StartTLS.</td>
		</tr>
		<tr>
			<td>configMap.notifier.smtp.disable_html_emails</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Disables sending HTML formatted emails.</td>
		</tr>
		<tr>
			<td>configMap.notifier.smtp.disable_require_tls</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>By default we require some form of TLS. This disables this check though is not advised.</td>
		</tr>
		<tr>
			<td>configMap.notifier.smtp.disable_starttls</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Some SMTP servers ignore SMTP specifications and claim to support STARTTLS when they in fact do not. For security reasons Authelia refuses to send messages to these servers. This option disables this measure and is enabled AT YOUR OWN RISK.</td>
		</tr>
		<tr>
			<td>configMap.notifier.smtp.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Enables the SMTP Provider (Notifier).</td>
		</tr>
		<tr>
			<td>configMap.notifier.smtp.identifier</td>
			<td>string</td>
			<td><pre lang="json">
"localhost"
</pre>
</td>
			<td>HELO/EHLO Identifier. Some SMTP Servers may reject the default of localhost.</td>
		</tr>
		<tr>
			<td>configMap.notifier.smtp.password.disabled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Disables this secret and leaves configuring it entirely up to you.</td>
		</tr>
		<tr>
			<td>configMap.notifier.smtp.password.path</td>
			<td>string</td>
			<td><pre lang="json">
"notifier.smtp.password.txt"
</pre>
</td>
			<td>The path to the secret. If it has a '/' prefix it's assumed to be an absolute path within the pod. Otherwise it uses the format '{mountPath}/{secret_name}/{path}' where '{mountPath}' refers to the 'secret.mountPath' value, '{secret_name}' is the secret_name above, and '{path}' is this value.</td>
		</tr>
		<tr>
			<td>configMap.notifier.smtp.password.secret_name</td>
			<td>string</td>
			<td><pre lang="json">
null
</pre>
</td>
			<td>The secret name. The ~ name is special as it is the secret we generate either automatically or via the secret_value option below.</td>
		</tr>
		<tr>
			<td>configMap.notifier.smtp.password.value</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>The value of a generated secret when using the ~ secret_name.</td>
		</tr>
		<tr>
			<td>configMap.notifier.smtp.sender</td>
			<td>string</td>
			<td><pre lang="json">
"Authelia \u003cadmin@example.com\u003e"
</pre>
</td>
			<td>The sender is used to construct both the SMTP command MAIL FROM and to add the FROM header. This address must be in RFC5322 format.</td>
		</tr>
		<tr>
			<td>configMap.notifier.smtp.startup_check_address</td>
			<td>string</td>
			<td><pre lang="json">
"test@authelia.com"
</pre>
</td>
			<td>This address is used during the startup check to verify the email configuration is correct. It's not important what it is except if your email server only allows local delivery.</td>
		</tr>
		<tr>
			<td>configMap.notifier.smtp.subject</td>
			<td>string</td>
			<td><pre lang="json">
"[Authelia] {title}"
</pre>
</td>
			<td>Subject configuration of the emails sent. {title} is replaced by the text from the notifier</td>
		</tr>
		<tr>
			<td>configMap.notifier.smtp.timeout</td>
			<td>string</td>
			<td><pre lang="json">
"5 seconds"
</pre>
</td>
			<td>The SMTP connection timeout.</td>
		</tr>
		<tr>
			<td>configMap.notifier.smtp.tls.maximum_version</td>
			<td>string</td>
			<td><pre lang="json">
"TLS1.3"
</pre>
</td>
			<td>Maximum TLS version for the connection.</td>
		</tr>
		<tr>
			<td>configMap.notifier.smtp.tls.minimum_version</td>
			<td>string</td>
			<td><pre lang="json">
"TLS1.2"
</pre>
</td>
			<td>Minimum TLS version for the connection.</td>
		</tr>
		<tr>
			<td>configMap.notifier.smtp.tls.server_name</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>The server subject name to check the servers certificate against during the validation process. This option is not required if the certificate has a SAN which matches the host option.</td>
		</tr>
		<tr>
			<td>configMap.notifier.smtp.tls.skip_verify</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Skip verifying the server certificate entirely.</td>
		</tr>
		<tr>
			<td>configMap.notifier.smtp.username</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>The username sent for authentication with the SMTP server. Paired with the password.</td>
		</tr>
		<tr>
			<td>configMap.ntp.address</td>
			<td>string</td>
			<td><pre lang="json">
"udp://time.cloudflare.com:123"
</pre>
</td>
			<td>NTP server address.</td>
		</tr>
		<tr>
			<td>configMap.ntp.disable_failure</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>The default of false will prevent startup only if we can contact the NTP server and the time is out of sync with the NTP server more than the configured max_desync. If you set this to true, an error will be logged but startup will continue regardless of results.</td>
		</tr>
		<tr>
			<td>configMap.ntp.disable_startup_check</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Disables the NTP check on startup entirely. This means Authelia will not contact a remote service at all if you set this to true, and can operate in a truly offline mode.</td>
		</tr>
		<tr>
			<td>configMap.ntp.max_desync</td>
			<td>string</td>
			<td><pre lang="json">
"3 seconds"
</pre>
</td>
			<td>Maximum allowed time offset between the host and the NTP server.</td>
		</tr>
		<tr>
			<td>configMap.ntp.version</td>
			<td>int</td>
			<td><pre lang="json">
4
</pre>
</td>
			<td>NTP version.</td>
		</tr>
		<tr>
			<td>configMap.password_policy.standard.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Enables standard password policy.</td>
		</tr>
		<tr>
			<td>configMap.password_policy.standard.max_length</td>
			<td>int</td>
			<td><pre lang="json">
0
</pre>
</td>
			<td>Require a maximum length for passwords.</td>
		</tr>
		<tr>
			<td>configMap.password_policy.standard.min_length</td>
			<td>int</td>
			<td><pre lang="json">
8
</pre>
</td>
			<td>Require a minimum length for passwords.</td>
		</tr>
		<tr>
			<td>configMap.password_policy.standard.require_lowercase</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Require lowercase characters.</td>
		</tr>
		<tr>
			<td>configMap.password_policy.standard.require_number</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Require numeric characters.</td>
		</tr>
		<tr>
			<td>configMap.password_policy.standard.require_special</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Require special characters.</td>
		</tr>
		<tr>
			<td>configMap.password_policy.standard.require_uppercase</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Require uppercase characters.</td>
		</tr>
		<tr>
			<td>configMap.password_policy.zxcvbn.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Enables zxcvbn password policy.</td>
		</tr>
		<tr>
			<td>configMap.password_policy.zxcvbn.min_score</td>
			<td>int</td>
			<td><pre lang="json">
0
</pre>
</td>
			<td>Configures the minimum score allowed.</td>
		</tr>
		<tr>
			<td>configMap.regulation.ban_time</td>
			<td>string</td>
			<td><pre lang="json">
"5 minutes"
</pre>
</td>
			<td>The length of time before a banned user can login again. Ban Time accepts duration notation. See: https://www.authelia.com/configuration/prologue/common/#duration-notation-format</td>
		</tr>
		<tr>
			<td>configMap.regulation.find_time</td>
			<td>string</td>
			<td><pre lang="json">
"2 minutes"
</pre>
</td>
			<td>The time range during which the user can attempt login before being banned. The user is banned if the authentication failed 'max_retries' times in a 'find_time' window. Find Time accepts duration notation. See: https://www.authelia.com/configuration/prologue/common/#duration-notation-format</td>
		</tr>
		<tr>
			<td>configMap.regulation.max_retries</td>
			<td>int</td>
			<td><pre lang="json">
3
</pre>
</td>
			<td>The number of failed login attempts before user is banned. Set it to 0 to disable regulation.</td>
		</tr>
		<tr>
			<td>configMap.regulation.modes</td>
			<td>list</td>
			<td><pre lang="json">
[
  "user"
]
</pre>
</td>
			<td>The regulation modes to use. The active modes determines what is banned in the event of a regulation ban being triggered as well as what logs to inspect to determine if a ban is needed. Default is just user, but ip is also available.</td>
		</tr>
		<tr>
			<td>configMap.server.asset_path</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>Set the path on disk to Authelia assets. Useful to allow overriding of specific static assets.</td>
		</tr>
		<tr>
			<td>configMap.server.buffers.read</td>
			<td>int</td>
			<td><pre lang="json">
4096
</pre>
</td>
			<td>Read buffer.</td>
		</tr>
		<tr>
			<td>configMap.server.buffers.write</td>
			<td>int</td>
			<td><pre lang="json">
4096
</pre>
</td>
			<td>Write buffer.</td>
		</tr>
		<tr>
			<td>configMap.server.endpoints.authz</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Dictionary of individually configured Authz endpoints.</td>
		</tr>
		<tr>
			<td>configMap.server.endpoints.automatic_authz_implementations</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td>A list of automatically configured authz implementations if you don't wish to manually configure each one. Important Note: If you configure the 'authz' section this is completely ignored.</td>
		</tr>
		<tr>
			<td>configMap.server.endpoints.enable_expvars</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Enable the developer expvars handlers.</td>
		</tr>
		<tr>
			<td>configMap.server.endpoints.enable_pprof</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Enable the developer pprof handlers.</td>
		</tr>
		<tr>
			<td>configMap.server.headers.csp_template</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>Read the Authelia docs before setting this advanced option. https://www.authelia.com/configuration/miscellaneous/server/#csp_template.</td>
		</tr>
		<tr>
			<td>configMap.server.path</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>Set the single level path Authelia listens on.  Must be alphanumeric chars and should not contain any slashes.</td>
		</tr>
		<tr>
			<td>configMap.server.port</td>
			<td>int</td>
			<td><pre lang="json">
9091
</pre>
</td>
			<td>Port sets the configured port for the daemon, service, and the probes. Default is 9091 and should not need to be changed.</td>
		</tr>
		<tr>
			<td>configMap.server.timeouts.idle</td>
			<td>string</td>
			<td><pre lang="json">
"30 seconds"
</pre>
</td>
			<td>Idle timeout.</td>
		</tr>
		<tr>
			<td>configMap.server.timeouts.read</td>
			<td>string</td>
			<td><pre lang="json">
"6 seconds"
</pre>
</td>
			<td>Read timeout.</td>
		</tr>
		<tr>
			<td>configMap.server.timeouts.write</td>
			<td>string</td>
			<td><pre lang="json">
"6 seconds"
</pre>
</td>
			<td>Write timeout.</td>
		</tr>
		<tr>
			<td>configMap.session.cookies</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td>Session Cookies list.</td>
		</tr>
		<tr>
			<td>configMap.session.encryption_key.disabled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Disables this secret and leaves configuring it entirely up to you.</td>
		</tr>
		<tr>
			<td>configMap.session.encryption_key.path</td>
			<td>string</td>
			<td><pre lang="json">
"session.encryption.key"
</pre>
</td>
			<td>The path to the secret. If it has a '/' prefix it's assumed to be an absolute path within the pod. Otherwise it uses the format '{mountPath}/{secret_name}/{path}' where '{mountPath}' refers to the 'secret.mountPath' value, '{secret_name}' is the secret_name above, and '{path}' is this value.</td>
		</tr>
		<tr>
			<td>configMap.session.encryption_key.secret_name</td>
			<td>string</td>
			<td><pre lang="json">
null
</pre>
</td>
			<td>The secret name. The ~ name is special as it is the secret we generate either automatically or via the secret_value option below.</td>
		</tr>
		<tr>
			<td>configMap.session.encryption_key.value</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>The value of a generated secret when using the ~ secret_name.</td>
		</tr>
		<tr>
			<td>configMap.session.expiration</td>
			<td>string</td>
			<td><pre lang="json">
"1 hour"
</pre>
</td>
			<td>The time before the cookie expires and session is reset.</td>
		</tr>
		<tr>
			<td>configMap.session.inactivity</td>
			<td>string</td>
			<td><pre lang="json">
"5 minutes"
</pre>
</td>
			<td>The inactivity time before the session is reset.</td>
		</tr>
		<tr>
			<td>configMap.session.name</td>
			<td>string</td>
			<td><pre lang="json">
"authelia_session"
</pre>
</td>
			<td>The name of the session cookie. (default: authelia_session).</td>
		</tr>
		<tr>
			<td>configMap.session.redis.database_index</td>
			<td>int</td>
			<td><pre lang="json">
0
</pre>
</td>
			<td>This is the Redis DB Index https://redis.io/commands/select (sometimes referred to as database number, DB, etc).</td>
		</tr>
		<tr>
			<td>configMap.session.redis.deploy</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Deploy the redis bitnami chart.</td>
		</tr>
		<tr>
			<td>configMap.session.redis.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Enable the use of redis.</td>
		</tr>
		<tr>
			<td>configMap.session.redis.high_availability.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Enable the use of redis sentinel.</td>
		</tr>
		<tr>
			<td>configMap.session.redis.high_availability.nodes</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td>The additional nodes to pre-seed the redis provider with (for sentinel). If the host in the above section is defined, it will be combined with this list to connect to sentinel. For high availability to be used you must have either defined; the host above or at least one node below.</td>
		</tr>
		<tr>
			<td>configMap.session.redis.high_availability.password.disabled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Disables this secret and leaves configuring it entirely up to you.</td>
		</tr>
		<tr>
			<td>configMap.session.redis.high_availability.password.path</td>
			<td>string</td>
			<td><pre lang="json">
"session.redis.sentinel.password.txt"
</pre>
</td>
			<td>The path to the secret. If it has a '/' prefix it's assumed to be an absolute path within the pod. Otherwise it uses the format '{mountPath}/{secret_name}/{path}' where '{mountPath}' refers to the 'secret.mountPath' value, '{secret_name}' is the secret_name above, and '{path}' is this value.</td>
		</tr>
		<tr>
			<td>configMap.session.redis.high_availability.password.secret_name</td>
			<td>string</td>
			<td><pre lang="json">
null
</pre>
</td>
			<td>The secret name. The ~ name is special as it is the secret we generate either automatically or via the secret_value option below.</td>
		</tr>
		<tr>
			<td>configMap.session.redis.high_availability.password.value</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>The value of a generated secret when using the ~ secret_name.</td>
		</tr>
		<tr>
			<td>configMap.session.redis.high_availability.route_by_latency</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Choose the host with the lowest latency.</td>
		</tr>
		<tr>
			<td>configMap.session.redis.high_availability.route_randomly</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Choose the host randomly.</td>
		</tr>
		<tr>
			<td>configMap.session.redis.high_availability.sentinel_name</td>
			<td>string</td>
			<td><pre lang="json">
"mysentinel"
</pre>
</td>
			<td>Sentinel Name / Master Name</td>
		</tr>
		<tr>
			<td>configMap.session.redis.high_availability.username</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>The Redis Sentinel-specific username. If supplied, authentication will be done via Redis 6+ ACL-based authentication. If left blank, authentication to sentinels will be done via `requirepass`.</td>
		</tr>
		<tr>
			<td>configMap.session.redis.host</td>
			<td>string</td>
			<td><pre lang="json">
"redis.databases.svc.cluster.local"
</pre>
</td>
			<td>The redis host or unix socket path. If utilising an IPv6 literal address it must be enclosed by square brackets and quoted.</td>
		</tr>
		<tr>
			<td>configMap.session.redis.maximum_active_connections</td>
			<td>int</td>
			<td><pre lang="json">
8
</pre>
</td>
			<td>The maximum number of concurrent active connections to Redis.</td>
		</tr>
		<tr>
			<td>configMap.session.redis.minimum_idle_connections</td>
			<td>int</td>
			<td><pre lang="json">
0
</pre>
</td>
			<td>The target number of idle connections to have open ready for work. Useful when opening connections is slow.</td>
		</tr>
		<tr>
			<td>configMap.session.redis.password.disabled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Disables this secret and leaves configuring it entirely up to you.</td>
		</tr>
		<tr>
			<td>configMap.session.redis.password.path</td>
			<td>string</td>
			<td><pre lang="json">
"session.redis.password.txt"
</pre>
</td>
			<td>The path to the secret. If it has a '/' prefix it's assumed to be an absolute path within the pod. Otherwise it uses the format '{mountPath}/{secret_name}/{path}' where '{mountPath}' refers to the 'secret.mountPath' value, '{secret_name}' is the secret_name above, and '{path}' is this value.</td>
		</tr>
		<tr>
			<td>configMap.session.redis.password.secret_name</td>
			<td>string</td>
			<td><pre lang="json">
null
</pre>
</td>
			<td>The secret name. The ~ name is special as it is the secret we generate either automatically or via the secret_value option below.</td>
		</tr>
		<tr>
			<td>configMap.session.redis.password.value</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>The value of a generated secret when using the ~ secret_name.</td>
		</tr>
		<tr>
			<td>configMap.session.redis.port</td>
			<td>int</td>
			<td><pre lang="json">
6379
</pre>
</td>
			<td>The port redis is listening on.</td>
		</tr>
		<tr>
			<td>configMap.session.redis.tls.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Enables rendering this TLS config.</td>
		</tr>
		<tr>
			<td>configMap.session.redis.tls.maximum_version</td>
			<td>string</td>
			<td><pre lang="json">
"TLS1.3"
</pre>
</td>
			<td>Maximum TLS version for the connection.</td>
		</tr>
		<tr>
			<td>configMap.session.redis.tls.minimum_version</td>
			<td>string</td>
			<td><pre lang="json">
"TLS1.2"
</pre>
</td>
			<td>Minimum TLS version for the connection.</td>
		</tr>
		<tr>
			<td>configMap.session.redis.tls.server_name</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>The server subject name to check the servers certificate against during the validation process. This option is not required if the certificate has a SAN which matches the host option.</td>
		</tr>
		<tr>
			<td>configMap.session.redis.tls.skip_verify</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Skip verifying the server certificate entirely.</td>
		</tr>
		<tr>
			<td>configMap.session.redis.username</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>Optional username to be used with authentication.</td>
		</tr>
		<tr>
			<td>configMap.session.remember_me</td>
			<td>string</td>
			<td><pre lang="json">
"1 month"
</pre>
</td>
			<td>The remember me duration.</td>
		</tr>
		<tr>
			<td>configMap.session.same_site</td>
			<td>string</td>
			<td><pre lang="json">
"lax"
</pre>
</td>
			<td>Sets the Cookie SameSite value. Possible options are none, lax, or strict. Please read https://www.authelia.com/configuration/session/introduction/#same_site</td>
		</tr>
		<tr>
			<td>configMap.storage.encryption_key.disabled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Disables this secret and leaves configuring it entirely up to you.</td>
		</tr>
		<tr>
			<td>configMap.storage.encryption_key.path</td>
			<td>string</td>
			<td><pre lang="json">
"storage.encryption.key"
</pre>
</td>
			<td>The path to the secret. If it has a '/' prefix it's assumed to be an absolute path within the pod. Otherwise it uses the format '{mountPath}/{secret_name}/{path}' where '{mountPath}' refers to the 'secret.mountPath' value, '{secret_name}' is the secret_name above, and '{path}' is this value.</td>
		</tr>
		<tr>
			<td>configMap.storage.encryption_key.secret_name</td>
			<td>string</td>
			<td><pre lang="json">
null
</pre>
</td>
			<td>The secret name. The ~ name is special as it is the secret we generate either automatically or via the secret_value option below.</td>
		</tr>
		<tr>
			<td>configMap.storage.encryption_key.value</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>The value of a generated secret when using the ~ secret_name.</td>
		</tr>
		<tr>
			<td>configMap.storage.local.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Enable the Local Provider (Storage / SQL)</td>
		</tr>
		<tr>
			<td>configMap.storage.local.path</td>
			<td>string</td>
			<td><pre lang="json">
"/config/db.sqlite3"
</pre>
</td>
			<td>Path to the SQLite3 database.</td>
		</tr>
		<tr>
			<td>configMap.storage.mysql.address</td>
			<td>string</td>
			<td><pre lang="json">
"tcp://mysql.databases.svc.cluster.local:3306"
</pre>
</td>
			<td>Configures the address for the MySQL/MariaDB Server. The address itself is a connector and the scheme must either be the unix scheme or one of the tcp schemes.</td>
		</tr>
		<tr>
			<td>configMap.storage.mysql.database</td>
			<td>string</td>
			<td><pre lang="json">
"authelia"
</pre>
</td>
			<td>The database name on the database server that the assigned user has access to for the purpose of Authelia.</td>
		</tr>
		<tr>
			<td>configMap.storage.mysql.deploy</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Deploy the MySQL Chart.</td>
		</tr>
		<tr>
			<td>configMap.storage.mysql.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Enable the MySQL Provider (Storage / SQL).</td>
		</tr>
		<tr>
			<td>configMap.storage.mysql.password.disabled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Disables this secret and leaves configuring it entirely up to you.</td>
		</tr>
		<tr>
			<td>configMap.storage.mysql.password.path</td>
			<td>string</td>
			<td><pre lang="json">
"storage.mysql.password.txt"
</pre>
</td>
			<td>The path to the secret. If it has a '/' prefix it's assumed to be an absolute path within the pod. Otherwise it uses the format '{mountPath}/{secret_name}/{path}' where '{mountPath}' refers to the 'secret.mountPath' value, '{secret_name}' is the secret_name above, and '{path}' is this value.</td>
		</tr>
		<tr>
			<td>configMap.storage.mysql.password.secret_name</td>
			<td>string</td>
			<td><pre lang="json">
null
</pre>
</td>
			<td>The secret name. The ~ name is special as it is the secret we generate either automatically or via the secret_value option below.</td>
		</tr>
		<tr>
			<td>configMap.storage.mysql.password.value</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>The value of a generated secret when using the ~ secret_name.</td>
		</tr>
		<tr>
			<td>configMap.storage.mysql.timeout</td>
			<td>string</td>
			<td><pre lang="json">
"5 seconds"
</pre>
</td>
			<td>The SQL connection timeout.</td>
		</tr>
		<tr>
			<td>configMap.storage.mysql.tls.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Enables rendering this TLS config.</td>
		</tr>
		<tr>
			<td>configMap.storage.mysql.tls.maximum_version</td>
			<td>string</td>
			<td><pre lang="json">
"TLS1.3"
</pre>
</td>
			<td>Maximum TLS version for the connection.</td>
		</tr>
		<tr>
			<td>configMap.storage.mysql.tls.minimum_version</td>
			<td>string</td>
			<td><pre lang="json">
"TLS1.2"
</pre>
</td>
			<td>Minimum TLS version for the connection.</td>
		</tr>
		<tr>
			<td>configMap.storage.mysql.tls.server_name</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>The server subject name to check the servers certificate against during the validation process. This option is not required if the certificate has a SAN which matches the host option.</td>
		</tr>
		<tr>
			<td>configMap.storage.mysql.tls.skip_verify</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Skip verifying the server certificate entirely.</td>
		</tr>
		<tr>
			<td>configMap.storage.mysql.username</td>
			<td>string</td>
			<td><pre lang="json">
"authelia"
</pre>
</td>
			<td>The username paired with the password used to connect to the database.</td>
		</tr>
		<tr>
			<td>configMap.storage.postgres.address</td>
			<td>string</td>
			<td><pre lang="json">
"tcp://postgres.databases.svc.cluster.local:5432"
</pre>
</td>
			<td>Configures the address for the PostgreSQL Server. The address itself is a connector and the scheme must either be the unix scheme or one of the tcp schemes.</td>
		</tr>
		<tr>
			<td>configMap.storage.postgres.database</td>
			<td>string</td>
			<td><pre lang="json">
"authelia"
</pre>
</td>
			<td>The database name on the database server that the assigned user has access to for the purpose of Authelia.</td>
		</tr>
		<tr>
			<td>configMap.storage.postgres.deploy</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Deploy the PostgreSQL Chart.</td>
		</tr>
		<tr>
			<td>configMap.storage.postgres.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Enable the PostgreSQL Provider (Storage / SQL).</td>
		</tr>
		<tr>
			<td>configMap.storage.postgres.password.disabled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Disables this secret and leaves configuring it entirely up to you.</td>
		</tr>
		<tr>
			<td>configMap.storage.postgres.password.path</td>
			<td>string</td>
			<td><pre lang="json">
"storage.postgres.password.txt"
</pre>
</td>
			<td>The path to the secret. If it has a '/' prefix it's assumed to be an absolute path within the pod. Otherwise it uses the format '{mountPath}/{secret_name}/{path}' where '{mountPath}' refers to the 'secret.mountPath' value, '{secret_name}' is the secret_name above, and '{path}' is this value.</td>
		</tr>
		<tr>
			<td>configMap.storage.postgres.password.secret_name</td>
			<td>string</td>
			<td><pre lang="json">
null
</pre>
</td>
			<td>The secret name. The ~ name is special as it is the secret we generate either automatically or via the secret_value option below.</td>
		</tr>
		<tr>
			<td>configMap.storage.postgres.password.value</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>The value of a generated secret when using the ~ secret_name.</td>
		</tr>
		<tr>
			<td>configMap.storage.postgres.schema</td>
			<td>string</td>
			<td><pre lang="json">
"public"
</pre>
</td>
			<td>The database schema name to use on the database server that the assigned user has access to for the purpose of Authelia. By default this is the public schema.</td>
		</tr>
		<tr>
			<td>configMap.storage.postgres.servers</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td>This specifies a list of additional fallback PostgreSQL instances to use should issues occur with the primary instance which is configured with the address and tls options.</td>
		</tr>
		<tr>
			<td>configMap.storage.postgres.timeout</td>
			<td>string</td>
			<td><pre lang="json">
"5 seconds"
</pre>
</td>
			<td>The SQL connection timeout.</td>
		</tr>
		<tr>
			<td>configMap.storage.postgres.tls.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Enables rendering this TLS config.</td>
		</tr>
		<tr>
			<td>configMap.storage.postgres.tls.maximum_version</td>
			<td>string</td>
			<td><pre lang="json">
"TLS1.3"
</pre>
</td>
			<td>Maximum TLS version for the connection.</td>
		</tr>
		<tr>
			<td>configMap.storage.postgres.tls.minimum_version</td>
			<td>string</td>
			<td><pre lang="json">
"TLS1.2"
</pre>
</td>
			<td>Minimum TLS version for the connection.</td>
		</tr>
		<tr>
			<td>configMap.storage.postgres.tls.server_name</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>The server subject name to check the servers certificate against during the validation process. This option is not required if the certificate has a SAN which matches the host option.</td>
		</tr>
		<tr>
			<td>configMap.storage.postgres.tls.skip_verify</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Skip verifying the server certificate entirely.</td>
		</tr>
		<tr>
			<td>configMap.storage.postgres.username</td>
			<td>string</td>
			<td><pre lang="json">
"authelia"
</pre>
</td>
			<td>The username paired with the password used to connect to the database.</td>
		</tr>
		<tr>
			<td>configMap.telemetry.metrics.buffers.read</td>
			<td>int</td>
			<td><pre lang="json">
4096
</pre>
</td>
			<td>Read buffer.</td>
		</tr>
		<tr>
			<td>configMap.telemetry.metrics.buffers.write</td>
			<td>int</td>
			<td><pre lang="json">
4096
</pre>
</td>
			<td>Write buffer.</td>
		</tr>
		<tr>
			<td>configMap.telemetry.metrics.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Enable Metrics.</td>
		</tr>
		<tr>
			<td>configMap.telemetry.metrics.port</td>
			<td>int</td>
			<td><pre lang="json">
9959
</pre>
</td>
			<td>The port to listen on for metrics. This should be on a different port to the main server.port value.</td>
		</tr>
		<tr>
			<td>configMap.telemetry.metrics.serviceMonitor.annotations</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Extra annotations for the ServiceMonitor manifest.</td>
		</tr>
		<tr>
			<td>configMap.telemetry.metrics.serviceMonitor.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Enable generating a Prometheus ServiceMonitor.</td>
		</tr>
		<tr>
			<td>configMap.telemetry.metrics.serviceMonitor.labels</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Extra labels for the ServiceMonitor manifest.</td>
		</tr>
		<tr>
			<td>configMap.telemetry.metrics.timeouts.idle</td>
			<td>string</td>
			<td><pre lang="json">
"30 seconds"
</pre>
</td>
			<td>Idle timeout.</td>
		</tr>
		<tr>
			<td>configMap.telemetry.metrics.timeouts.read</td>
			<td>string</td>
			<td><pre lang="json">
"6 seconds"
</pre>
</td>
			<td>Read timeout.</td>
		</tr>
		<tr>
			<td>configMap.telemetry.metrics.timeouts.write</td>
			<td>string</td>
			<td><pre lang="json">
"6 seconds"
</pre>
</td>
			<td>Write timeout.</td>
		</tr>
		<tr>
			<td>configMap.theme</td>
			<td>string</td>
			<td><pre lang="json">
"light"
</pre>
</td>
			<td>Theme name to use for the frontend.</td>
		</tr>
		<tr>
			<td>configMap.totp.algorithm</td>
			<td>string</td>
			<td><pre lang="json">
"SHA1"
</pre>
</td>
			<td>The TOTP algorithm to use. It is CRITICAL you read the documentation before changing this option: https://www.authelia.com/configuration/second-factor/time-based-one-time-password/#algorithm</td>
		</tr>
		<tr>
			<td>configMap.totp.allowed_algorithms</td>
			<td>list</td>
			<td><pre lang="json">
[
  "SHA1"
]
</pre>
</td>
			<td>Similar to algorithm with the same restrictions except this option allows users to pick from this list. This list will always contain the value configured in the algorithm option.</td>
		</tr>
		<tr>
			<td>configMap.totp.allowed_digits</td>
			<td>list</td>
			<td><pre lang="json">
[
  6
]
</pre>
</td>
			<td>Similar to digits with the same restrictions except this option allows users to pick from this list. This list will always contain the value configured in the digits option.</td>
		</tr>
		<tr>
			<td>configMap.totp.allowed_periods</td>
			<td>list</td>
			<td><pre lang="json">
[
  30
]
</pre>
</td>
			<td>Similar to period with the same restrictions except this option allows users to pick from this list. This list will always contain the value configured in the period option.</td>
		</tr>
		<tr>
			<td>configMap.totp.digits</td>
			<td>int</td>
			<td><pre lang="json">
6
</pre>
</td>
			<td>The number of digits a user has to input. Must either be 6 or 8. Changing this option only affects newly generated TOTP configurations. It is CRITICAL you read the documentation before changing this option: https://www.authelia.com/configuration/second-factor/time-based-one-time-password/#digits</td>
		</tr>
		<tr>
			<td>configMap.totp.disable</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Disable TOTP.</td>
		</tr>
		<tr>
			<td>configMap.totp.issuer</td>
			<td>string</td>
			<td><pre lang="json">
"Authelia"
</pre>
</td>
			<td>The issuer name displayed in the Authenticator application of your choice. Defaults to 'Authelia'.</td>
		</tr>
		<tr>
			<td>configMap.totp.period</td>
			<td>int</td>
			<td><pre lang="json">
30
</pre>
</td>
			<td>The period in seconds a one-time password is valid for. Changing this option only affects newly generated TOTP configurations.</td>
		</tr>
		<tr>
			<td>configMap.totp.secret_size</td>
			<td>int</td>
			<td><pre lang="json">
32
</pre>
</td>
			<td>The size of the generated shared secrets. Default is 32 and is sufficient in most use cases, minimum is 20.</td>
		</tr>
		<tr>
			<td>configMap.totp.skew</td>
			<td>int</td>
			<td><pre lang="json">
1
</pre>
</td>
			<td>The skew controls number of one-time passwords either side of the current one that are valid. Warning: before changing skew read the docs link below. See: https://www.authelia.com/configuration/second-factor/time-based-one-time-password/#input-validation to read the documentation.</td>
		</tr>
		<tr>
			<td>configMap.webauthn.attestation_conveyance_preference</td>
			<td>string</td>
			<td><pre lang="json">
"indirect"
</pre>
</td>
			<td>Conveyance preference controls if we collect the attestation statement including the AAGUID from the device. Options are none, indirect, direct.</td>
		</tr>
		<tr>
			<td>configMap.webauthn.disable</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Disable Webauthn.</td>
		</tr>
		<tr>
			<td>configMap.webauthn.display_name</td>
			<td>string</td>
			<td><pre lang="json">
"Authelia"
</pre>
</td>
			<td>The display name the browser should show the user for when using Webauthn to login/register.</td>
		</tr>
		<tr>
			<td>configMap.webauthn.enable_passkey_login</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Enabled Passkey Logins.</td>
		</tr>
		<tr>
			<td>configMap.webauthn.filtering.permitted_aaguids</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td>A list of Authenticator Attestation GUID’s that are the only ones allowed to be registered. Useful if you have a company policy that requires certain authenticators. Mutually exclusive with prohibited_aaguids.</td>
		</tr>
		<tr>
			<td>configMap.webauthn.filtering.prohibit_backup_eligibility</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Setting this value to true will ensure Authenticators which can export credentials will not be able to register. This will likely prevent synchronized credentials from being registered.</td>
		</tr>
		<tr>
			<td>configMap.webauthn.filtering.prohibited_aaguids</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td>A list of Authenticator Attestation GUID’s that users will not be able to register. Useful if company policy prevents certain authenticators. Mutually exclusive with permitted_aaguids.</td>
		</tr>
		<tr>
			<td>configMap.webauthn.metadata.cache_policy</td>
			<td>string</td>
			<td><pre lang="json">
"strict"
</pre>
</td>
			<td>Allows adjusting the WebAuthn Metadata Cache Policy.</td>
		</tr>
		<tr>
			<td>configMap.webauthn.metadata.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Enables metadata service validation of authenticators and credentials. This requires the download of the metadata service blob which will utilize about 5MB of data in your configured storage backend.</td>
		</tr>
		<tr>
			<td>configMap.webauthn.metadata.validate_entry</td>
			<td>bool</td>
			<td><pre lang="json">
true
</pre>
</td>
			<td>Enables validation that an entry exists for the authenticator in the MDS3 blob. It’s recommended that this option is the default value, however this may exclude some authenticators which DO NOT have FIDO compliance certification or have otherwise not registered with the MDS3. The recommendation is based on the fact that the authenticity of a particular authenticator cannot be validated without this.</td>
		</tr>
		<tr>
			<td>configMap.webauthn.metadata.validate_entry_permit_zero_aaguid</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Allows authenticators which have provided an empty Authenticator Attestation GUID. This may be required for certain authenticators which DO NOT have FIDO compliance certification.</td>
		</tr>
		<tr>
			<td>configMap.webauthn.metadata.validate_status</td>
			<td>bool</td>
			<td><pre lang="json">
true
</pre>
</td>
			<td>Enables validation of the attestation entry statuses. There is generally never a reason to disable this as the authenticators excluded by default are likely compromised.</td>
		</tr>
		<tr>
			<td>configMap.webauthn.metadata.validate_status_permitted</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td>A list of exclusively required statuses for an authenticator to pass validation.</td>
		</tr>
		<tr>
			<td>configMap.webauthn.metadata.validate_status_prohibited</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td>A list of authenticator statuses which for an authenticator that are prohibited from being registered.</td>
		</tr>
		<tr>
			<td>configMap.webauthn.metadata.validate_trust_anchor</td>
			<td>bool</td>
			<td><pre lang="json">
true
</pre>
</td>
			<td>Enables validation of the attestation certificate against the Certificate Authority certificate in the validated MDS3 blob. It’s recommended this value is always the default value.</td>
		</tr>
		<tr>
			<td>configMap.webauthn.selection_criteria.attachment</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>Sets the attachment preference for newly created credentials.</td>
		</tr>
		<tr>
			<td>configMap.webauthn.selection_criteria.discoverability</td>
			<td>string</td>
			<td><pre lang="json">
"preferred"
</pre>
</td>
			<td>Sets the discoverability preference. May affect the creation of Passkeys.</td>
		</tr>
		<tr>
			<td>configMap.webauthn.selection_criteria.user_verification</td>
			<td>string</td>
			<td><pre lang="json">
"preferred"
</pre>
</td>
			<td>Sets the user verification preference.</td>
		</tr>
		<tr>
			<td>configMap.webauthn.timeout</td>
			<td>string</td>
			<td><pre lang="json">
"60 seconds"
</pre>
</td>
			<td>Adjust the interaction timeout for Webauthn dialogues.</td>
		</tr>
		<tr>
			<td>enabled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>This field can be used as a condition when authelia is a dependency. This definition is only a placeholder and not used directly by this chart. See https://helm.sh/docs/chart_best_practices/dependencies/#conditions-and-tags for more info</td>
		</tr>
		<tr>
			<td>image.pullPolicy</td>
			<td>string</td>
			<td><pre lang="json">
"IfNotPresent"
</pre>
</td>
			<td>The pull policy for the standard image.</td>
		</tr>
		<tr>
			<td>image.pullSecrets</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td>The pull secrets to use.</td>
		</tr>
		<tr>
			<td>image.registry</td>
			<td>string</td>
			<td><pre lang="json">
"ghcr.io"
</pre>
</td>
			<td>The registry to use.</td>
		</tr>
		<tr>
			<td>image.repository</td>
			<td>string</td>
			<td><pre lang="json">
"authelia/authelia"
</pre>
</td>
			<td>The repository location on the registry.</td>
		</tr>
		<tr>
			<td>image.tag</td>
			<td>string</td>
			<td><pre lang="">
appVersion
</pre>
</td>
			<td>The tag to use from the registry.</td>
		</tr>
		<tr>
			<td>ingress.annotations</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Extra annotations for ingress related manifests.</td>
		</tr>
		<tr>
			<td>ingress.certManager</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Enable Cert Manager annotations.</td>
		</tr>
		<tr>
			<td>ingress.className</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>Ingress Class Name for the Ingress manifests.</td>
		</tr>
		<tr>
			<td>ingress.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Enable generating ingress related resources.</td>
		</tr>
		<tr>
			<td>ingress.gatewayAPI.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Enable Gateway API HTTP Route generation.</td>
		</tr>
		<tr>
			<td>ingress.gatewayAPI.hostnamesOverride</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td>Override the hostnames for the HTTPRoute manifest.</td>
		</tr>
		<tr>
			<td>ingress.gatewayAPI.parentRefs</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td>Configure the parent references for the HTTPRoute manifest.</td>
		</tr>
		<tr>
			<td>ingress.labels</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Extra labels for ingress related manifests.</td>
		</tr>
		<tr>
			<td>ingress.rulesOverride</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td>Override to the rules values for the Ingress type manifest.</td>
		</tr>
		<tr>
			<td>ingress.tls.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Enable TLS for the Ingress.</td>
		</tr>
		<tr>
			<td>ingress.tls.secret</td>
			<td>string</td>
			<td><pre lang="json">
"authelia-tls"
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>ingress.traefikCRD.apiGroupOverride</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>The apiGroupOverride overrides the first part of the apiVersion for TraefikCRD manifests.</td>
		</tr>
		<tr>
			<td>ingress.traefikCRD.apiVersionOverride</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>The apiVersionOverride overrides the second part of the apiVersion for TraefikCRD manifests.</td>
		</tr>
		<tr>
			<td>ingress.traefikCRD.disableIngressRoute</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Use a standard Ingress object, not an IngressRoute.</td>
		</tr>
		<tr>
			<td>ingress.traefikCRD.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Enable generating the Traefik 3.x CRD Middleware etc manifests.</td>
		</tr>
		<tr>
			<td>ingress.traefikCRD.entryPoints</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td>Defines the valid entryPoints to route for the IngressRoute.</td>
		</tr>
		<tr>
			<td>ingress.traefikCRD.matchOverride</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>IngressRoute match rule override.</td>
		</tr>
		<tr>
			<td>ingress.traefikCRD.middlewares.auth.authResponseHeaders</td>
			<td>list</td>
			<td><pre lang="json">
[
  "Remote-User",
  "Remote-Name",
  "Remote-Email",
  "Remote-Groups"
]
</pre>
</td>
			<td>Defines the ForwardAuth Middleware Auth Response Headers.</td>
		</tr>
		<tr>
			<td>ingress.traefikCRD.middlewares.auth.endpointOverride</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>Overrides the endpoint used for the middleware. This is the portion of the endpoint after '/api/authz/'.</td>
		</tr>
		<tr>
			<td>ingress.traefikCRD.middlewares.auth.nameOverride</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>Overrides the ForwardAuth Middleware (auth) name.</td>
		</tr>
		<tr>
			<td>ingress.traefikCRD.middlewares.chains.auth.after</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td>List of Middlewares to apply after the forwardAuth Middleware in the authentication chain.</td>
		</tr>
		<tr>
			<td>ingress.traefikCRD.middlewares.chains.auth.before</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td>List of Middlewares to apply before the forwardAuth Middleware in the authentication chain.</td>
		</tr>
		<tr>
			<td>ingress.traefikCRD.middlewares.chains.auth.nameOverride</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>Overrides the Chain Middleware (auth) name.</td>
		</tr>
		<tr>
			<td>ingress.traefikCRD.middlewares.chains.ingressRoute.after</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td>List of Middlewares to apply after the middleware in the IngressRoute chain.</td>
		</tr>
		<tr>
			<td>ingress.traefikCRD.middlewares.chains.ingressRoute.before</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td>List of Middlewares to apply before the middleware in the IngressRoute chain.</td>
		</tr>
		<tr>
			<td>ingress.traefikCRD.priority</td>
			<td>int</td>
			<td><pre lang="json">
500
</pre>
</td>
			<td>Defines the rule priority for the IngressRoute.</td>
		</tr>
		<tr>
			<td>ingress.traefikCRD.responseForwardingFlushInterval</td>
			<td>string</td>
			<td><pre lang="json">
"100ms"
</pre>
</td>
			<td>Defines the Response Forwarding Flush Interval for the IngressRoute.</td>
		</tr>
		<tr>
			<td>ingress.traefikCRD.sticky</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Defines the sticky value for the IngressRoute.</td>
		</tr>
		<tr>
			<td>ingress.traefikCRD.stickyCookieNameOverride</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>Overrides the default sticky cookie name for the IngressRoute.</td>
		</tr>
		<tr>
			<td>ingress.traefikCRD.strategy</td>
			<td>string</td>
			<td><pre lang="json">
"RoundRobin"
</pre>
</td>
			<td>Defines the IngressRoute service strategy.</td>
		</tr>
		<tr>
			<td>ingress.traefikCRD.tls.certResolver</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>Name of the Certificate Resolver to use.</td>
		</tr>
		<tr>
			<td>ingress.traefikCRD.tls.disableTLSOptions</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Disables inclusion of the IngressRoute TLSOptions.</td>
		</tr>
		<tr>
			<td>ingress.traefikCRD.tls.domainsOverride</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td>Override the domains values for TLS operations.</td>
		</tr>
		<tr>
			<td>ingress.traefikCRD.tls.options.cipherSuites</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td>Override the default Cipher Suites.</td>
		</tr>
		<tr>
			<td>ingress.traefikCRD.tls.options.curvePreferences</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td>Override the default Curve Preferences.</td>
		</tr>
		<tr>
			<td>ingress.traefikCRD.tls.options.maxVersion</td>
			<td>string</td>
			<td><pre lang="json">
"VersionTLS13"
</pre>
</td>
			<td>Maximum TLS Version.</td>
		</tr>
		<tr>
			<td>ingress.traefikCRD.tls.options.minVersion</td>
			<td>string</td>
			<td><pre lang="json">
"VersionTLS12"
</pre>
</td>
			<td>Minimum TLS Version.</td>
		</tr>
		<tr>
			<td>ingress.traefikCRD.tls.options.nameOverride</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>Override the TLSOptions name.</td>
		</tr>
		<tr>
			<td>ingress.traefikCRD.tls.options.sniStrict</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Require Strict SNI requirement.</td>
		</tr>
		<tr>
			<td>ingress.traefikCRD.weight</td>
			<td>int</td>
			<td><pre lang="json">
10
</pre>
</td>
			<td>Defines the service weight for the IngressRoute.</td>
		</tr>
		<tr>
			<td>kubeDNSDomainOverride</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>Kubernetes DNS Domain Override allows forcibly overriding the default DNS Domain for Kubernetes 'cluster.local'.</td>
		</tr>
		<tr>
			<td>kubeVersionOverride</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>Kubernetes Version Override allows forcibly overriding the detected KubeVersion for fallback capabilities assessment. The fallback capabilities assessment only occurs if the APIVersions Capabilities list does not include a known # APIVersion for a manifest which occurs with some CI/CD tooling. This value will completely override the value detected by helm.</td>
		</tr>
		<tr>
			<td>labels</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Extra labels for all generated resources. Most manifest types have a more specific labels value associated with them.</td>
		</tr>
		<tr>
			<td>mariadb</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Configure mariadb database subchart under this key. This will be deployed when storage.mysql.deploy is set to true Currently settings need to be manually copied from here to the storage.mysql section For more options and to see the @default please see [mariadb chart documentation](https://github.com/bitnami/charts/tree/main/bitnami/mariadb)</td>
		</tr>
		<tr>
			<td>nameOverride</td>
			<td>string</td>
			<td><pre lang="json">
null
</pre>
</td>
			<td>The name override for this deployment.</td>
		</tr>
		<tr>
			<td>networkPolicy.annotations</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Extra annotations for the NetworkPolicy manifest.</td>
		</tr>
		<tr>
			<td>networkPolicy.egress</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>networkPolicy.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Enable the NetworkPolicy.</td>
		</tr>
		<tr>
			<td>networkPolicy.ingress</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>networkPolicy.labels</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Extra labels for the NetworkPolicy manifest.</td>
		</tr>
		<tr>
			<td>networkPolicy.policyTypes</td>
			<td>list</td>
			<td><pre lang="json">
[
  "Ingress"
]
</pre>
</td>
			<td>The Policy Types such as Ingress or Egress.</td>
		</tr>
		<tr>
			<td>persistence.accessModes</td>
			<td>list</td>
			<td><pre lang="json">
[
  "ReadWriteOnce"
]
</pre>
</td>
			<td>PersistentVolumeClaim access modes.</td>
		</tr>
		<tr>
			<td>persistence.annotations</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Extra annotations for the PersistentVolumeClaim related manifests.</td>
		</tr>
		<tr>
			<td>persistence.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Enable the PersistentVolumeClaim features for Authelia.</td>
		</tr>
		<tr>
			<td>persistence.existingClaim</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>Mounts an existing PersistentVolumeClaim.</td>
		</tr>
		<tr>
			<td>persistence.extraPersistentVolumeClaims.example.accessModes</td>
			<td>list</td>
			<td><pre lang="json">
[
  "ReadWriteOnce"
]
</pre>
</td>
			<td>PersistentVolumeClaim access modes.</td>
		</tr>
		<tr>
			<td>persistence.extraPersistentVolumeClaims.example.annotations</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Extra annotations for this PersistentVolumeClaim manifest.</td>
		</tr>
		<tr>
			<td>persistence.extraPersistentVolumeClaims.example.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Enable this extra PersistentVolumeClaim.</td>
		</tr>
		<tr>
			<td>persistence.extraPersistentVolumeClaims.example.existingClaim</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>Mounts an existing PersistentVolumeClaim.</td>
		</tr>
		<tr>
			<td>persistence.extraPersistentVolumeClaims.example.labels</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Extra annotations for this PersistentVolumeClaim manifest.</td>
		</tr>
		<tr>
			<td>persistence.extraPersistentVolumeClaims.example.mountPropagation</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>Sets the mount propagation value for the PersistentVolumeClaim.</td>
		</tr>
		<tr>
			<td>persistence.extraPersistentVolumeClaims.example.readOnly</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Mounts the PersistentVolumeClaim in read-only mode.</td>
		</tr>
		<tr>
			<td>persistence.extraPersistentVolumeClaims.example.selector</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>persistence.extraPersistentVolumeClaims.example.size</td>
			<td>string</td>
			<td><pre lang="json">
"100Mi"
</pre>
</td>
			<td>PersistentVolumeClaim volume size.</td>
		</tr>
		<tr>
			<td>persistence.extraPersistentVolumeClaims.example.storageClass</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>Uses the specified storageClass for the PersistentVolumeClaim.</td>
		</tr>
		<tr>
			<td>persistence.extraPersistentVolumeClaims.example.subPath</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>Mounts specifically a subpath of the PersistentVolumeClaim.</td>
		</tr>
		<tr>
			<td>persistence.extraPersistentVolumeClaims.example.subPathExpr</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>Uses an expression to mount a subpath of the PersistentVolumeClaim.</td>
		</tr>
		<tr>
			<td>persistence.extraPersistentVolumeClaims.example.volumeName</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>Persistent Volume Name. Useful if Persistent Volumes have been provisioned in advance and you want to use a specific one.</td>
		</tr>
		<tr>
			<td>persistence.labels</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Extra annotations for the PersistentVolumeClaim related manifests.</td>
		</tr>
		<tr>
			<td>persistence.mountPropagation</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>Sets the mount propagation value for the PersistentVolumeClaim.</td>
		</tr>
		<tr>
			<td>persistence.readOnly</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Mounts the PersistentVolumeClaim in read-only mode.</td>
		</tr>
		<tr>
			<td>persistence.selector</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>persistence.size</td>
			<td>string</td>
			<td><pre lang="json">
"100Mi"
</pre>
</td>
			<td>PersistentVolumeClaim volume size.</td>
		</tr>
		<tr>
			<td>persistence.storageClass</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>Uses the specified storageClass for the PersistentVolumeClaim.</td>
		</tr>
		<tr>
			<td>persistence.subPath</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>Mounts specifically a subpath of the PersistentVolumeClaim.</td>
		</tr>
		<tr>
			<td>persistence.subPathExpr</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>Uses an expression to mount a subpath of the PersistentVolumeClaim.</td>
		</tr>
		<tr>
			<td>persistence.volumeName</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>Persistent Volume Name. Useful if Persistent Volumes have been provisioned in advance and you want to use a specific one.</td>
		</tr>
		<tr>
			<td>pod.annotations</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Extra annotations for the Pod spec.</td>
		</tr>
		<tr>
			<td>pod.args</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td>Modifies the args for the command. Useful for debugging.</td>
		</tr>
		<tr>
			<td>pod.autoscaling.annotations</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Extra annotations for the HorizontalPodAutoscaler manifest.</td>
		</tr>
		<tr>
			<td>pod.autoscaling.behavior</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td></td>
		</tr>
		<tr>
			<td>pod.autoscaling.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Enable the HorizontalPodAutoscaler which requires the in cluster metrics server.</td>
		</tr>
		<tr>
			<td>pod.autoscaling.labels</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Extra labels for the HorizontalPodAutoscaler manifest.</td>
		</tr>
		<tr>
			<td>pod.command</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td>Modifies the command. Useful for debugging.</td>
		</tr>
		<tr>
			<td>pod.disableRestartOnChanges</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Normally when a change is detected via helm install to something that only indirectly affects the pod, the pod will restart. This setting allows disabling this behavior.</td>
		</tr>
		<tr>
			<td>pod.env</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td>List of additional environment variables for the Pod.</td>
		</tr>
		<tr>
			<td>pod.extraContainers</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td>Extra containers to add to the Pod spec.</td>
		</tr>
		<tr>
			<td>pod.extraVolumeMounts</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td>Extra Volume Mounts.</td>
		</tr>
		<tr>
			<td>pod.extraVolumes</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td>Extra Volumes.</td>
		</tr>
		<tr>
			<td>pod.initContainers</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td>The list of custom initialization containers.</td>
		</tr>
		<tr>
			<td>pod.kind</td>
			<td>string</td>
			<td><pre lang="json">
"DaemonSet"
</pre>
</td>
			<td>The Pod Kind to use. Must be Deployment, DaemonSet, or StatefulSet.</td>
		</tr>
		<tr>
			<td>pod.labels</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Extra labels for the Pod spec.</td>
		</tr>
		<tr>
			<td>pod.priorityClassName</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>The priority class name for the Pod spec.</td>
		</tr>
		<tr>
			<td>pod.probes.liveness.failureThreshold</td>
			<td>int</td>
			<td><pre lang="json">
5
</pre>
</td>
			<td>Liveness Probe failure threshold.</td>
		</tr>
		<tr>
			<td>pod.probes.liveness.initialDelaySeconds</td>
			<td>int</td>
			<td><pre lang="json">
0
</pre>
</td>
			<td>Liveness Probe initial delay seconds.</td>
		</tr>
		<tr>
			<td>pod.probes.liveness.periodSeconds</td>
			<td>int</td>
			<td><pre lang="json">
30
</pre>
</td>
			<td>Liveness Probe period seconds.</td>
		</tr>
		<tr>
			<td>pod.probes.liveness.successThreshold</td>
			<td>int</td>
			<td><pre lang="json">
1
</pre>
</td>
			<td>Liveness Probe success threshold.</td>
		</tr>
		<tr>
			<td>pod.probes.liveness.timeoutSeconds</td>
			<td>int</td>
			<td><pre lang="json">
5
</pre>
</td>
			<td>Liveness Probe timeout seconds.</td>
		</tr>
		<tr>
			<td>pod.probes.method.httpGet.path</td>
			<td>string</td>
			<td><pre lang="json">
"/api/health"
</pre>
</td>
			<td>Adjusts the probe path.</td>
		</tr>
		<tr>
			<td>pod.probes.method.httpGet.port</td>
			<td>string</td>
			<td><pre lang="json">
"http"
</pre>
</td>
			<td>Adjusts the probe port.</td>
		</tr>
		<tr>
			<td>pod.probes.method.httpGet.scheme</td>
			<td>string</td>
			<td><pre lang="json">
"HTTP"
</pre>
</td>
			<td>Adjusts the probe scheme.</td>
		</tr>
		<tr>
			<td>pod.probes.readiness.failureThreshold</td>
			<td>int</td>
			<td><pre lang="json">
5
</pre>
</td>
			<td>Readiness Probe failure threshold.</td>
		</tr>
		<tr>
			<td>pod.probes.readiness.initialDelaySeconds</td>
			<td>int</td>
			<td><pre lang="json">
0
</pre>
</td>
			<td>Readiness Probe initial delay seconds.</td>
		</tr>
		<tr>
			<td>pod.probes.readiness.periodSeconds</td>
			<td>int</td>
			<td><pre lang="json">
5
</pre>
</td>
			<td>Readiness Probe period seconds.</td>
		</tr>
		<tr>
			<td>pod.probes.readiness.successThreshold</td>
			<td>int</td>
			<td><pre lang="json">
1
</pre>
</td>
			<td>Readiness Probe success threshold.</td>
		</tr>
		<tr>
			<td>pod.probes.readiness.timeoutSeconds</td>
			<td>int</td>
			<td><pre lang="json">
5
</pre>
</td>
			<td>Readiness Probe timeout seconds.</td>
		</tr>
		<tr>
			<td>pod.probes.startup.failureThreshold</td>
			<td>int</td>
			<td><pre lang="json">
6
</pre>
</td>
			<td>Startup Probe failure threshold.</td>
		</tr>
		<tr>
			<td>pod.probes.startup.initialDelaySeconds</td>
			<td>int</td>
			<td><pre lang="json">
10
</pre>
</td>
			<td>Startup Probe initial delay seconds.</td>
		</tr>
		<tr>
			<td>pod.probes.startup.periodSeconds</td>
			<td>int</td>
			<td><pre lang="json">
5
</pre>
</td>
			<td>Startup Probe period seconds.</td>
		</tr>
		<tr>
			<td>pod.probes.startup.successThreshold</td>
			<td>int</td>
			<td><pre lang="json">
1
</pre>
</td>
			<td>Startup Probe success threshold.</td>
		</tr>
		<tr>
			<td>pod.probes.startup.timeoutSeconds</td>
			<td>int</td>
			<td><pre lang="json">
5
</pre>
</td>
			<td>Startup Probe timeout seconds.</td>
		</tr>
		<tr>
			<td>pod.replicas</td>
			<td>int</td>
			<td><pre lang="json">
1
</pre>
</td>
			<td>The number of replicas if relevant.</td>
		</tr>
		<tr>
			<td>pod.resources.limits</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Resource Limits.</td>
		</tr>
		<tr>
			<td>pod.resources.requests</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Resource Requests.</td>
		</tr>
		<tr>
			<td>pod.revisionHistoryLimit</td>
			<td>int</td>
			<td><pre lang="json">
5
</pre>
</td>
			<td>The revision history limit.</td>
		</tr>
		<tr>
			<td>pod.securityContext.container</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Container Security Context.</td>
		</tr>
		<tr>
			<td>pod.securityContext.pod</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Pod Security Context.</td>
		</tr>
		<tr>
			<td>pod.selectors.affinity.nodeAffinity</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Node affinity selector.</td>
		</tr>
		<tr>
			<td>pod.selectors.affinity.podAffinity</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Pod affinity selector.</td>
		</tr>
		<tr>
			<td>pod.selectors.affinity.podAntiAffinity</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Pod anti-affinity selector.</td>
		</tr>
		<tr>
			<td>pod.selectors.nodeName</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>Specific node name selector.</td>
		</tr>
		<tr>
			<td>pod.selectors.nodeSelector</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Node selector.</td>
		</tr>
		<tr>
			<td>pod.strategy.rollingUpdate.maxSurge</td>
			<td>string</td>
			<td><pre lang="json">
"25%"
</pre>
</td>
			<td>RollingUpdate max surge value.</td>
		</tr>
		<tr>
			<td>pod.strategy.rollingUpdate.maxUnavailable</td>
			<td>string</td>
			<td><pre lang="json">
"25%"
</pre>
</td>
			<td>RollingUpdate max unavailable value.</td>
		</tr>
		<tr>
			<td>pod.strategy.rollingUpdate.partition</td>
			<td>int</td>
			<td><pre lang="json">
0
</pre>
</td>
			<td>RollingUpdate partition value.</td>
		</tr>
		<tr>
			<td>pod.strategy.type</td>
			<td>string</td>
			<td><pre lang="json">
"RollingUpdate"
</pre>
</td>
			<td>Deployment Strategy Type.</td>
		</tr>
		<tr>
			<td>pod.tolerations</td>
			<td>list</td>
			<td><pre lang="json">
[]
</pre>
</td>
			<td>List of tolerations.</td>
		</tr>
		<tr>
			<td>podDisruptionBudget.annotations</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Extra annotations for the PodDisruptionBudget manifest.</td>
		</tr>
		<tr>
			<td>podDisruptionBudget.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Enable the PodDisruptionBudget.</td>
		</tr>
		<tr>
			<td>podDisruptionBudget.labels</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Extra labels for the PodDisruptionBudget manifest.</td>
		</tr>
		<tr>
			<td>podDisruptionBudget.maxUnavailable</td>
			<td>int</td>
			<td><pre lang="json">
0
</pre>
</td>
			<td>Maximum available value for the PodDisruptionBudget manifest.</td>
		</tr>
		<tr>
			<td>podDisruptionBudget.minAvailable</td>
			<td>int</td>
			<td><pre lang="json">
0
</pre>
</td>
			<td>Minimum available value for the PodDisruptionBudget manifest.</td>
		</tr>
		<tr>
			<td>postgresql</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Configure postgresql database subchart under this key. This will be deployed when storage.postgres.deploy is set to true Currently settings need to be manually copied from here to the storage.postgres section For more options and to see the @default please see [postgresql chart documentation](https://github.com/bitnami/charts/tree/main/bitnami/postgresql)</td>
		</tr>
		<tr>
			<td>rbac.annotations</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Extra annotations for RBAC related manifests.</td>
		</tr>
		<tr>
			<td>rbac.enabled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Enable RBAC. Turning this on associates Authelia with a service account.</td>
		</tr>
		<tr>
			<td>rbac.labels</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Extra labels for RBAC related manifests.</td>
		</tr>
		<tr>
			<td>rbac.serviceAccountName</td>
			<td>string</td>
			<td><pre lang="json">
"authelia"
</pre>
</td>
			<td>Kubernetes service account name to generate.</td>
		</tr>
		<tr>
			<td>redis</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Configure redis database subchart under this key. This will be deployed when session.redis.deploy is set to true Currently settings need to be manually copied from here to the session.redis section For more options and to see the @default please see [redis chart documentation](https://github.com/bitnami/charts/tree/main/bitnami/redis)</td>
		</tr>
		<tr>
			<td>secret.additionalSecrets</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Additional secrets to mount to the Pod.</td>
		</tr>
		<tr>
			<td>secret.annotations</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Extra annotations for the Secret manifest.</td>
		</tr>
		<tr>
			<td>secret.disabled</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Disable the Secret manifest functionality.</td>
		</tr>
		<tr>
			<td>secret.existingSecret</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>Name of an existing Secret manifest to mount instead of generating one.</td>
		</tr>
		<tr>
			<td>secret.labels</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Extra labels for the Secret manifest.</td>
		</tr>
		<tr>
			<td>secret.mountPath</td>
			<td>string</td>
			<td><pre lang="json">
"/secrets"
</pre>
</td>
			<td>Pod path to mount the values of the Secret manifest.</td>
		</tr>
		<tr>
			<td>service.annotations</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Extra annotations for service manifest.</td>
		</tr>
		<tr>
			<td>service.clusterIP</td>
			<td>string</td>
			<td><pre lang="json">
null
</pre>
</td>
			<td>Cluster IP for the Authelia service manifest.</td>
		</tr>
		<tr>
			<td>service.labels</td>
			<td>object</td>
			<td><pre lang="json">
{}
</pre>
</td>
			<td>Extra labels for service manifest.</td>
		</tr>
		<tr>
			<td>service.nodePort</td>
			<td>int</td>
			<td><pre lang="json">
30091
</pre>
</td>
			<td>Node Port for the Authelia service manifest.</td>
		</tr>
		<tr>
			<td>service.port</td>
			<td>int</td>
			<td><pre lang="json">
80
</pre>
</td>
			<td>Port for the Authelia service manifest.</td>
		</tr>
		<tr>
			<td>service.type</td>
			<td>string</td>
			<td><pre lang="json">
"ClusterIP"
</pre>
</td>
			<td>The service type to generate for the Authelia pods.</td>
		</tr>
		<tr>
			<td>versionOverride</td>
			<td>string</td>
			<td><pre lang="json">
""
</pre>
</td>
			<td>Version Override allows changing some chart characteristics that render only on specific versions. This does NOT affect the image used, please see the below image section instead for this. If this value is not specified, it's assumed the appVersion of the chart is the version. The format of this value  is x.x.x, for example 4.100.0. Minimum value is 4.38.0, and support is not guaranteed.</td>
		</tr>
	</tbody>
</table>

