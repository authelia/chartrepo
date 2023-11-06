{{/*
Returns the OpenID Connect 1.0 clients userinfo signed response alg.
*/}}
{{- define "authelia.config.oidc.client.userinfo_signed_response_alg" -}}
    {{- if .userinfo_signed_response_alg }}
        {{- .userinfo_signed_response_alg }}
    {{- else if .userinfo_signing_algorithm }}
        {{- .userinfo_signing_algorithm }}
    {{- else }}
        {{- "none" }}
    {{- end }}
{{- end }}
