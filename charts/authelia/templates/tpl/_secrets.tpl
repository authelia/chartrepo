{{/*
Returns if we should generate the secret
*/}}
{{- define "authelia.secrets.main.enabled" -}}
    {{- if .Values.secret -}}
        {{- if not (include "authelia.vaultInjector.enabled" .) }}
            {{- if not .Values.secret.existingSecret -}}
                {{- true -}}
            {{- else if eq "" .Values.secret.existingSecret -}}
            {{- true -}}
            {{- end -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Returns if we should generate the secret for certificates
*/}}
{{- define "authelia.secrets.certificates.name" -}}
    {{- if .Values.certificates -}}
        {{- if .Values.certificates.existingSecret -}}
            {{- .Values.certificates.existingSecret -}}
        {{- else -}}
            {{- printf "%s-certificates" (include "authelia.name" .) -}}
        {{- end -}}
    {{- else -}}
        {{- printf "%s-certificates" (include "authelia.name" .) -}}
    {{- end -}}
{{- end -}}

{{/*
Returns if we should generate the secret for certificates
*/}}
{{- define "authelia.secrets.certificates.enabled" -}}
    {{- if .Values.certificates -}}
        {{- if .Values.certificates.values -}}
            {{- true -}}
        {{- else if .Values.certificates.existingSecret -}}
            {{- true -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Returns if we should generate the secret for certificates
*/}}
{{- define "authelia.secrets.certificates.generate" -}}
    {{- if .Values.certificates -}}
        {{- if .Values.certificates.values -}}
            {{- if not .Values.certificates.existingSecret -}}
                {{- true -}}
            {{- else if eq "" .Values.certificates.existingSecret -}}
                {{- true -}}
            {{- end -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Returns the ACL secret name.
*/}}
{{- define "authelia.secrets.acl.name" -}}
    {{- default (printf "%s-acl" (include "authelia.name" .) | trunc 63 | trimSuffix "-") .Values.configMap.access_control.secret.existingSecret -}}
{{- end -}}

{{/*
Returns true if we should use the ACL Secret.
*/}}
{{- define "authelia.secrets.acl.enabled" -}}
    {{- if hasKey .Values "configMap" -}}
        {{- if .Values.configMap.enabled -}}
            {{- if .Values.configMap.access_control.secret.enabled }}
                {{- true -}}
            {{- end -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Returns true if we should use a generate the ACL Secret.
*/}}
{{- define "authelia.secrets.acl.generate" -}}
    {{- if and (include "authelia.secrets.acl.enabled" .) (not .Values.configMap.access_control.secret.existingSecret) -}}
        {{- true -}}
    {{- end -}}
{{- end -}}

{{/*
Returns true if we should use a mount the ACL Secret.
*/}}
{{- define "authelia.secrets.acl.mount" -}}
    {{- if or (include "authelia.secrets.acl.enabled" .) .Values.configMap.access_control.secret.existingSecret -}}
        {{- true -}}
    {{- end -}}
{{- end -}}

{{/*
Returns the value of .SecretValue or a randomly generated one
*/}}
{{- define "authelia.secret.standard" -}}
    {{- if and .SecretValue (not (eq .SecretValue "")) -}}
        {{- .SecretValue | b64enc -}}
    {{- else if and .LookupValue -}}
        {{- if (not (eq .LookupValue "")) -}}
            {{- .LookupValue -}}
        {{- else -}}
            {{- randAlphaNum 128 | b64enc -}}
        {{- end -}}
    {{- else -}}
        {{- randAlphaNum 128 | b64enc -}}
    {{- end -}}
{{- end -}}

{{/*
Returns the mountPath of the secrets.
*/}}
{{- define "authelia.secret.mountPath" -}}
    {{- default "/secrets" .Values.secret.mountPath -}}
{{- end -}}

{{- define "authelia.secret.path" -}}
    {{- if eq .Secret "jwt" -}}
        {{- default "JWT_TOKEN" .Values.secret.jwt.filename -}}
    {{- else if eq .Secret "storage" -}}
        {{- default "STORAGE_PASSWORD" .Values.secret.storage.filename -}}
    {{- else if eq .Secret "storageEncryptionKey" -}}
        {{- default "STORAGE_ENCRYPTION_KEY" .Values.secret.storageEncryptionKey.filename -}}
    {{- else if eq .Secret "session" -}}
        {{- default "SESSION_ENCRYPTION_KEY" .Values.secret.session.filename -}}
    {{- else if eq .Secret "ldap" -}}
        {{- default "LDAP_PASSWORD" .Values.secret.ldap.filename -}}
    {{- else if eq .Secret "smtp" -}}
        {{- default "SMTP_PASSWORD" .Values.secret.smtp.filename -}}
    {{- else if eq .Secret "duo" -}}
        {{- default "DUO_API_KEY" .Values.secret.duo.filename -}}
    {{- else if eq .Secret "redis" -}}
        {{- default "REDIS_PASSWORD" .Values.secret.redis.filename -}}
    {{- else if eq .Secret "redis-sentinel" -}}
        {{- default "REDIS_SENTINEL_PASSWORD" .Values.secret.redisSentinel.filename -}}
    {{- else if eq .Secret "oidc-private-key" -}}
        {{- default "OIDC_PRIVATE_KEY" .Values.secret.oidcPrivateKey.filename -}}
    {{- else if eq .Secret "oidc-hmac-secret" -}}
        {{- default "OIDC_HMAC_SECRET" .Values.secret.oidcHMACSecret.filename -}}
    {{- end -}}
{{- end -}}

{{- define "authelia.secret.fullPath" -}}
    {{- $path := (include "authelia.secret.mountPath" .) -}}
    {{- $filename := (include "authelia.secret.path" .) -}}
    {{- printf "%s/%s" $path $filename -}}
{{- end -}}