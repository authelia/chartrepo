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
{{- define "authelia.config.oidc.client.secret" -}}
    {{- if or .public (not .secret) }}
        {{- "" }}
    {{- else if kindIs "string" .secret }}
        {{- .secret }}
    {{- else if hasKey .secret "value" }}
        {{- .secret.value }}
    {{- end }}
{{- end }}

{{- define "authelia.config.oidc.client.secret.render" -}}
    {{- if not .public }}
        {{- if and (not (kindIs "string" .secret)) .secret.path }}
            {{- printf "{{ secret %s | squote }}" .secret.path }}
        {{- else }}
            {{- (include "authelia.config.oidc.client.secret" .) | squote }}
        {{- end }}
    {{- end }}
{{- end -}}