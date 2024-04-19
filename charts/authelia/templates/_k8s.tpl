{{/*
Returns an overridable Kubernetes DNS Domain
*/}}
{{- define "kube.DNSDomain" -}}
    {{- .Values.kubeDNSDomainOverride | default "cluster.local" -}}
{{- end -}}