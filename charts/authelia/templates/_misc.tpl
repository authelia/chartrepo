{{/*
    Returns the file configuration list as a csv.
*/}}
{{- define "authelia.config.paths" -}}
    {{- $paths := (list "/configuration.yaml") }}
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

{{/*
    squote a list joined by comma
*/}}
{{- define "authelia.squote.join" -}}
    {{- if kindIs "string" . }}
        {{- . | squote }}
    {{- else -}}
        {{- range $i, $val := . -}}
            {{- if $i -}}
                {{- print ", " -}}
            {{- end -}}
            {{- $val | squote -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
    Wraps something with YAML header/footer
*/}}
{{- define "authelia.wrapYAML" -}}
{{- "---" }}
{{ . }}
{{ "..." }}
{{- end -}}

{{/*
    squote a list joined by comma
*/}}
{{- define "authelia.squote.list" -}}
{{- range . }}
{{ printf "- %s" (. | squote) }}
{{- end }}
{{- end -}}
