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
    {{- if .public }}
        {{- "" }}
    {{- else if kindIs "string" .client_secret }}
        {{- .client_secret }}
    {{- else if and (kindIs "map" .client_secret) (hasKey .client_secret "value") }}
        {{- .client_secret.value }}
    {{- end }}
{{- end }}

{{- define "authelia.config.oidc.client.client_secret.render" -}}
    {{- if not .public }}
        {{- if and (not (kindIs "string" .client_secret)) .client_secret.path }}
            {{- printf "'{{ secret \"%s\" }}'" .client_secret.path }}
        {{- else }}
            {{- (include "authelia.config.oidc.client.client_secret" .) | squote }}
        {{- end }}
    {{- end }}
{{- end -}}

{{- define "authelia.config.oidc.client.pkce_challenge_method" -}}
    {{- if .enforce_pkce }}
    {{- .pkce_challenge_method | default "S256" -}}
    {{- else }}
    {{- .pkce_challenge_method | default "" -}}
    {{- end }}
{{- end -}}