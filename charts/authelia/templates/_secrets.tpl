{{/*
Given a path outputs a filter valid template for that path including multiline detection.
*/}}
{{- define "authelia.secrets.template" -}}
{{- printf "{{ secret %s | mindent %d \"|\" | msquote }}" (.Path | quote) .Indent }}
{{- end }}

{{- define "authelia.secret.path.ldap" -}}
{{- end -}}

{{/*
Returns the value of .SecretValue or a randomly generated one
*/}}
{{- define "authelia.secret.value.standard" -}}
    {{- if .Secret.value -}}
        {{- .Secret.value | b64enc -}}
    {{- else }}
        {{- $lookup := (get .Lookup .Secret.path) | default false }}
        {{- if $lookup }}
            {{- $lookup }}
        {{- else }}
            {{- randAlphaNum 128 | b64enc -}}
        {{- end }}
    {{- end }}
{{- end -}}

{{- define "authelia.secret.generate" -}}
    {{- if and (not .disabled) (not .secret_name) (not (hasPrefix "/" .path)) }}
        {{- true }}
    {{- end }}
{{- end -}}

{{- define "authelia.secret.env.path" -}}
    {{- if (hasPrefix "/" .SecretPath) }}
        {{ .path | squote }}
    {{- else }}
        {{- (printf "%s/%s/%s" .MountPath (.SecretName | default "internal") .SecretPath) | squote }}
    {{- end }}
{{- end -}}

{{- define "authelia.secret.path.reset_password.jwt" -}}
    {{- .Values.configMap.identity_validation.reset_password.secret.path | default "identity_validation.reset_password.jwt.hmac.key" }}
{{- end -}}

{{- define "authelia.secret.path.session.encryption_key" -}}
    {{- .Values.configMap.session.encryption_key.path | default "session.encryption.key" }}
{{- end -}}

{{- define "authelia.secret.path.redis.password" -}}
    {{- .Values.configMap.session.redis.password.path | default "session.redis.password.txt" }}
{{- end -}}

{{- define "authelia.secret.path.redis.sentinel.password" -}}
    {{- .Values.configMap.session.redis.high_availability.password.path | default "session.redis.sentinel.password.txt" }}
{{- end -}}

{{- define "authelia.secret.path.ldap.password" -}}
    {{- .Values.configMap.authentication_backend.ldap.password.path | default "authentication.ldap.password.txt" }}
{{- end -}}

{{- define "authelia.secret.path.smtp.password" -}}
    {{- .Values.configMap.notifier.smtp.password.path | default "notifier.smtp.password.txt" }}
{{- end -}}

{{- define "authelia.secret.path.storage.encryption_key" -}}
    {{- .Values.configMap.storage.encryption_key.path | default "storage.encryption.key" }}
{{- end -}}

{{- define "authelia.secret.path.postgres.password" -}}
    {{- .Values.configMap.storage.postgres.password.path | default "storage.postgres.password.txt" }}
{{- end -}}

{{- define "authelia.secret.path.mysql.password" -}}
    {{- .Values.configMap.storage.mysql.password.path | default "storage.mysql.password.txt" }}
{{- end -}}

{{- define "authelia.secret.path.duo" -}}
    {{- .Values.configMap.duo_api.secret.path | default "duo.key" }}
{{- end -}}

{{- define "authelia.secret.path.oidc.hmac_key" -}}
    {{- .Values.configMap.identity_providers.oidc.hmac_secret.path | default "identity_providers.oidc.hmac.key" }}
{{- end -}}

