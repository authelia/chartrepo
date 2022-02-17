{{/*
Return the proper image name
*/}}
{{- define "authelia.image" -}}
    {{- $registryName := default "docker.io" .Values.image.registry -}}
    {{- $repositoryName := default "authelia/authelia" .Values.image.repository -}}
    {{- $tag := default .Chart.AppVersion .Values.image.tag | toString -}}
    {{- if hasPrefix "sha256:" $tag }}
    {{- printf "%s/%s@%s" $registryName $repositoryName $tag -}}
    {{- else -}}
    {{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
    {{- end -}}
{{- end -}}

{{/*
Return the name for this install
*/}}
{{- define "authelia.name" -}}
    {{- if .Values.nameOverride -}}
        {{- .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
    {{- else -}}
        {{- $name := default .Chart.Name .Values.nameOverride -}}
        {{- if contains $name .Release.Name -}}
            {{- .Release.Name | trunc 63 | trimSuffix "-" -}}
        {{- else -}}
            {{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Return the name for this chart
*/}}
{{- define "authelia.chart" -}}
    {{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Returns true if pod is stateful.
*/}}
{{- define "authelia.stateful" -}}
    {{- if .Values.configMap -}}
        {{- if .Values.configMap.enabled -}}
            {{- if .Values.configMap.authentication_backend.file.enabled -}}
                {{- true -}}
            {{- else if .Values.configMap.storage.local.enabled -}}
                {{- true -}}
            {{- else if not .Values.configMap.session.redis.enabled -}}
                {{- true -}}
            {{- else if and (not .Values.configMap.storage.mysql.enabled) (not .Values.configMap.storage.postgres.enabled) -}}
                {{- true -}}
            {{- else if not .Values.configMap.authentication_backend.ldap.enabled -}}
                {{- true -}}
            {{- end -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Returns the common labels
*/}}
{{- define "authelia.labels" -}}
    {{ include "authelia.labels.match" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ include "authelia.chart" . }}
    {{- if .Values.labels }}
        {{- toYaml .Values.labels | nindent 0 }}
    {{- end }}
    {{- if .Labels }}
        {{- toYaml .Labels | nindent 0 }}
    {{- end }}
{{- end -}}

{{/*
Returns the match labels
*/}}
{{- define "authelia.labels.match" -}}
app.kubernetes.io/name: {{ .Values.appNameOverride | default .Chart.Name | trunc 63 | trimSuffix "-" }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Returns the common annotations
*/}}
{{- define "authelia.annotations" -}}
    {{- $annotations := dict -}}
    {{- if .Values.annotations -}}
        {{ $annotations = mergeOverwrite $annotations .Values.annotations -}}
    {{- end -}}
    {{- if hasKey . "Annotations" -}}
        {{ $annotations = mergeOverwrite $annotations .Annotations -}}
    {{- end -}}
    {{- if $annotations -}}
        {{- toYaml $annotations | indent 0 -}}
    {{- end -}}
{{- end -}}

{{/*
Returns the service port.
*/}}
{{- define "authelia.service.port" -}}
    {{- if .Values.service -}}
        {{- if .Values.service.port -}}
            {{- .Values.service.port -}}
        {{- else -}}
            {{- 80 -}}
        {{- end -}}
    {{- else -}}
        {{- 80 -}}
    {{- end -}}
{{- end -}}

{{/*
Returns true if we should generate a ConfigMap.
*/}}
{{- define "authelia.configMap.generate" -}}
    {{- if include "authelia.configMap.enabled" . -}}
        {{- if not .Values.configMap.existingConfigMap -}}
            {{- true -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Returns true if we should use a ConfigMap.
*/}}
{{- define "authelia.configMap.enabled" -}}
    {{- if .Values.configMap -}}
        {{- if .Values.configMap.enabled -}}
            {{- true -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Returns true if we should use a PDB.
*/}}
{{- define "authelia.podDisruptionBudget.enabled" -}}
    {{- if .Values.podDisruptionBudget -}}
        {{- if .Values.podDisruptionBudget.enabled -}}
            {{- true -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Returns if we should generate the NetworkPolicy.
*/}}
{{- define "authelia.networkPolicy.enabled" -}}
    {{- if .Values.networkPolicy -}}
        {{- if .Values.networkPolicy.enabled -}}
            {{- true -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Returns if we should generate the PersistentVolumeClaim.
*/}}
{{- define "authelia.persistentVolumeClaim.enabled" -}}
    {{- if .Values.persistence -}}
        {{- if .Values.persistence.enabled -}}
            {{- true -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Returns if we should generate the PersistentVolumeClaim.
*/}}
{{- define "authelia.persistentVolumeClaim.generate" -}}
    {{- if include "authelia.persistentVolumeClaim.enabled" . -}}
        {{- if not .Values.persistence.existingClaim -}}
            {{- true -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Renders a probe
{{ include "authelia.snippets.probe" (dict "Probe" .Values.path.to.the.probe "Method" .Values.path.to.the.method) }}
*/}}
{{- define "authelia.merge.probe" -}}
    {{- if and .Method .Probe .Type -}}
        {{- $probe := dict -}}
        {{- $probe = merge $probe .Method -}}
        {{- $probe = merge $probe .Probe -}}
        {{- if eq "startup" .Type -}}
            {{ toYaml (dict "startupProbe" $probe) }}
        {{- else if eq "liveness" .Type -}}
            {{ toYaml (dict "livenessProbe" $probe) }}
        {{- else if eq "readiness" .Type -}}
            {{ toYaml (dict "readinessProbe" $probe) }}
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