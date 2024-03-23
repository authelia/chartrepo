{{/*
Returns the OpenID Connect 1.0 clients token endpoint authentication method.
*/}}
{{- define "authelia.config.oidc.client.token_endpoint_auth_method" -}}
    {{- if .public }}
        {{- .token_endpoint_auth_method | default "none" }}
    {{- else }}
        {{- .token_endpoint_auth_method | default "client_secret_basic" }}
    {{- end }}
{{- end }}


{{/*
Returns the OpenID Connect 1.0 clients secret.
*/}}
{{- define "authelia.config.oidc.client.client_secret" -}}
    {{- if or .public (not .client_secret) }}
        {{- "" }}
    {{- else if kindIs "string" .client_secret }}
        {{- .client_secret }}
    {{- else if hasKey .client_secret "value" }}
        {{- .client_secret.value }}
    {{- end }}
{{- end }}

{{- define "authelia.config.oidc.client.client_secret.render" -}}
    {{- if not .public }}
        {{- if and (not (kindIs "string" .client_secret)) .client_secret.path }}
            {{- printf "{{ client_secret %s | squote }}" .client_secret.path }}
        {{- else }}
            {{- (include "authelia.config.oidc.client.client_secret" .) | squote }}
        {{- end }}
    {{- end }}
{{- end -}}