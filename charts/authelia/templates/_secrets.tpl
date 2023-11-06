{{/*
Given a path outputs a filter valid template for that path including multiline detection.
*/}}
{{- define "authelia.secrets.template" -}}
{{- printf "{{ secret %s | mindent %d \"|\" | msquote }}" (.Path | quote) .Indent }}
{{- end }}
