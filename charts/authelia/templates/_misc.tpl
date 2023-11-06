{{/*
Returns the file configuration list as a csv.
*/}}
{{- define "authelia.config.paths" -}}
    {{- $paths := (list "/configuration.yml") }}
    {{- if (include "authelia.mount.acl.secret" .) }}
        {{- $paths = append $paths "/configuration.acl.yaml" }}
    {{- end }}
    {{- if .Values.configMap.extraConfigs }}
        {{- $paths = concat $paths .Values.configMap.extraConfigs }}
    {{- end }}
    {{- join "," $paths }}
{{- end }}

{{/*
Performs squote on a duration.
*/}}
{{- define "authelia.func.dquote" }}
{{- if kindIs "string" . }}
    {{- . | squote }}
{{- else }}
    {{- . }}
{{- end }}
{{- end }}