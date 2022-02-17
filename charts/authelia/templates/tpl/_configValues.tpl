{{/*
Returns the path value.
*/}}
{{- define "authelia.path" -}}
    {{- if .Values.configMap -}}
        {{- if .Values.configMap.path -}}
            {{- .Values.configMap.path -}}
        {{- else -}}
            {{- "/" -}}
        {{- end -}}
    {{- else -}}
        {{- "/" -}}
    {{- end -}}
{{- end -}}

{{/*
Returns true if duo is enabled.
*/}}
{{- define "authelia.duo.enabled" -}}
    {{- if .Values.configMap -}}
        {{- if and .Values.configMap.duo_api -}}
            {{- if and .Values.configMap.duo_api.enabled -}}
                {{- if and (hasKey .Values.configMap.duo_api "integration_key") (hasKey .Values.configMap.duo_api "hostname") -}}-}}
                    {{- true -}}
                {{- end -}}
            {{- end -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Returns true if duo secret is configured.
*/}}
{{- define "authelia.duo.secret.enabled" -}}
    {{- if .Values.secret -}}
        {{- if .Values.secret.duo -}}
            {{- if hasKey .Values.secret.duo "value" -}}
                {{- if not (eq .Values.secret.duo.value "") -}}
                    {{- true -}}
                {{- end -}}
            {{- end -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{- define "authelia.accessControl.defaultPolicy" }}
    {{- $defaultPolicy := "deny" }}
    {{- if (eq (len .Values.configMap.access_control.rules) 0) }}
        {{- if (eq .Values.configMap.access_control.default_policy "bypass") }}
            {{- $defaultPolicy = "one_factor" }}
        {{- else if (eq .Values.configMap.access_control.default_policy "deny") }}
            {{- $defaultPolicy = "two_factor" }}
        {{- else }}
            {{- $defaultPolicy = .Values.configMap.access_control.default_policy }}
        {{- end }}
    {{- else }}
        {{- $defaultPolicy = .Values.configMap.access_control.default_policy }}
    {{- end }}
    {{ $defaultPolicy }}
{{- end }}
