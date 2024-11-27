{{/*
    Return the default endpoint name.
*/}}
{{- define "authelia.authz.name" -}}
    {{- if eq .Implementation "AuthRequest" }}
        {{- "auth-request" }}
    {{- else if eq .Implementation "ExtAuthz" }}
        {{- "ext-authz" }}
    {{- else if eq .Implementation "ForwardAuth" }}
        {{- "forward-auth" }}
    {{- else if eq .Implementation "Legacy" }}
        {{- "legacy" }}
    {{- end }}
{{- end -}}


{{/*
    Returns the Authz configuration as JSON.
*/}}
{{- define "authelia.authz" -}}
    {{- $authz := dict }}
    {{- if .Values.configMap.server.endpoints.automatic_authz_implementations }}
        {{- range $implementation := .Values.configMap.server.endpoints.automatic_authz_implementations }}
            {{- $name := (include "authelia.authz.name" (dict "Implementation" $implementation)) }}
            {{- if $name }}
                {{- $_ := set $authz $name (dict "implementation" $implementation "authn_strategies" list) }}
            {{- end }}
        {{- end }}
    {{- else if .Values.configMap.server.endpoints.authz }}
        {{- $authz = deepCopy .Values.configMap.server.endpoints.authz }}
    {{- else }}
        {{- $authz = dict "auth-request" (dict "implementation" "AuthRequest" "authn_strategies" list) "ext-authz" (dict "implementation" "ExtAuthz" "authn_strategies" list) "forward-auth" (dict "implementation" "ForwardAuth" "authn_strategies" list) }}
    {{- end }}
    {{- $authz | toJson }}
{{- end -}}

{{- define "authelia.authz.implementations" -}}
    {{ (list "AuthRequest" "ExtAuthz" "ForwardAuth" "Legacy") | toJson }}
{{- end -}}