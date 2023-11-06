{{/*
Returns the file configuration list as a csv.
*/}}
{{- define "authelia.ingress.host" -}}
    {{- if .SubDomain }}
    {{- printf "%s.%s" .SubDomain .Domain }}
    {{- else }}
    {{- .Domain }}
    {{- end }}
{{- end }}

{{/*
Returns the forward auth url
*/}}
{{- define "authelia.forwardAuthPath" -}}
    {{- $scheme := "http" -}}
    {{- $host := printf "%s.%s" (include "authelia.name" .) .Release.Namespace -}}
    {{- $cluster := "cluster.local" -}}
    {{- if .Namespace -}}
        {{- $host = printf "%s.%s" $host .Namespace -}}
    {{- end -}}
    {{- if .Cluster -}}
        {{- $cluster := .Cluster -}}
    {{- end -}}
    {{- $path := (include "authelia.path" .) | trimSuffix "/" -}}
    {{- (printf "%s://%s.svc.%s%s/api/authz/%s" $scheme $host $cluster $path (.Values.ingress.traefikCRD.middlewares.auth.endpointOverride | default "forward-auth")) -}}
{{- end -}}