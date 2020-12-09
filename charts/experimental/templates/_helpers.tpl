{{/*
Return the proper image name
*/}}
{{- define "authelia.image" -}}
{{- $registryName := .Values.image.registry -}}
{{- $repositoryName := .Values.image.repository -}}
{{- $tag := .Values.image.tag | toString -}}
    {{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
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
Returns if we should generate the secret
*/}}
{{- define "authelia.generateSecret" -}}
{{- if .Values.authelia.secret.existingSecretName -}}
    {{- false -}}
{{- else -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Returns the common labels
*/}}
{{- define "authelia.labels" -}}
{{ include "authelia.matchLabels" . }}
helm.sh/chart: {{ include "authelia.chart" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- if .Values.extraLabels -}}
{{ toYaml .Values.extraLabels }}
{{- end -}}
{{- end -}}

{{/*
Returns the match labels
*/}}
{{- define "authelia.matchLabels" -}}
app.kubernetes.io/name: {{ default .Chart.Name .Values.appNameOverride | trunc 63 | trimSuffix "-" }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Returns the common annotations
*/}}
{{- define "authelia.annotations" -}}
{{- if .Values.extraLabels -}}
{{ toYaml .Values.extraLabels }}
{{- end -}}
{{- end -}}


{{/*
Returns the jwt token or a randomly generated one
*/}}
{{- define "authelia.jwt_token" -}}
{{- if .Values.authelia.secret.jwt.value -}}
    {{- .Values.authelia.secret.jwt.value | b64enc -}}
{{- else -}}
    {{- randAlphaNum 128 | b64enc -}}
{{- end -}}
{{- end -}}

{{/*
Returns the session encryption key or a randomly generated one
*/}}
{{- define "authelia.session_encryption_key" -}}
{{- if .Values.authelia.secret.session.value -}}
    {{- .Values.authelia.secret.session.value | b64enc -}}
{{- else -}}
    {{- randAlphaNum 128 | b64enc -}}
{{- end -}}
{{- end -}}

{{/*
Returns the ldap password or a randomly generated one
*/}}
{{- define "authelia.ldap_password" -}}
{{- if .Values.authelia.secret.ldap.value -}}
    {{- .Values.authelia.secret.ldap.value | b64enc -}}
{{- else -}}
    {{- randAlphaNum 128 | b64enc -}}
{{- end -}}
{{- end -}}

{{/*
Returns the storage password or a randomly generated one
*/}}
{{- define "authelia.storage_password" -}}
{{- if .Values.authelia.secret.storage.value -}}
    {{- .Values.authelia.secret.storage.value | b64enc -}}
{{- else -}}
    {{- randAlphaNum 128 | b64enc -}}
{{- end -}}
{{- end -}}

{{/*
Returns the redis password or a randomly generated one
*/}}
{{- define "authelia.redis_password" -}}
{{- if .Values.authelia.secret.redis.value -}}
    {{- .Values.authelia.secret.redis.value | b64enc -}}
{{- else -}}
    {{- randAlphaNum 128 | b64enc -}}
{{- end -}}
{{- end -}}

{{/*
Returns the smtp password or a randomly generated one
*/}}
{{- define "authelia.smtp_password" -}}
{{- if .Values.authelia.secret.smtp.value -}}
    {{- .Values.authelia.secret.smtp.value | b64enc -}}
{{- else -}}
    {{- randAlphaNum 128 | b64enc -}}
{{- end -}}
{{- end -}}