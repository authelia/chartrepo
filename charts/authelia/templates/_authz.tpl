{{/*
Return the notes for a particular endpoint config.
*/}}
{{- define "authelia.authz.notes" -}}
    {{- if eq .Implementation "AuthRequest" }}
        {{ tpl ($.Files.Get "authz.notes.auth-request.txt") (merge (dict "APIVersion" (include "capabilities.apiVersion.ingress" $) "ServiceName" (printf "%s.%s" (include "authelia.name" $) $.Release.Namespace) "EndpointName" .EndpointName) $) }}
    {{- else if eq .Implementation "ExtAuthz" }}
        {{ tpl ($.Files.Get "authz.notes.ext-authz.txt") $ }}
    {{- else if eq .Implementation "ForwardAuth" }}
        {{ tpl ($.Files.Get "authz.notes.forward-auth.txt") (merge (dict "APIVersion" (include "capabilities.apiVersion.ingress" $) "CRDVersion" "traefik.io/v1alpha1" "MiddlewareName" (include "authelia.ingress.traefikCRD.middleware.name.chainAuth" $) "Namespace" $.Release.Namespace) $) }}
    {{- end }}
{{- end -}}

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
{{- end }}
{{- end -}}