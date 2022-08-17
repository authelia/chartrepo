{{/*
Returns if hashicorp injector is enabled
*/}}
{{- define "authelia.vaultInjector.enabled" -}}
    {{- if .Values.secret -}}
        {{- if .Values.secret.vaultInjector -}}
            {{- if .Values.secret.vaultInjector.enabled -}}
                {{- true -}}
            {{- end -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Returns the vault secret path.
*/}}
{{- define "authelia.vaultInjector.path" -}}
    {{- if . -}}
        {{ (split ":" .)._0 }}
    {{- end -}}
{{- end -}}

{{/*
Returns the injector secret template.
*/}}
{{- define "authelia.vaultInjector.template" -}}
    {{- if . -}}
        {{ printf "{{ with secret %q }}{{ .Data.%s }}{{ end }}" (split ":" .)._0 (split ":" .)._1 }}
    {{- end -}}
{{- end -}}