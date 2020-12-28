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
{{- if (not .Values.secret.existingSecretName) -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Returns if we should create the Ingress kind
*/}}
{{- define "authelia.ingress" -}}
{{- if and .Values.ingress.enabled (not (include "authelia.ingress.traefikCRD.enabled" .)) -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Returns if we should create the TraefikCRD kinds
*/}}
{{- define "authelia.ingress.traefikCRD.enabled" -}}
{{- if and .Values.ingress.enabled .Values.ingress.traefikCRD.enabled -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Returns if we should use existing TraefikCRD TLSOption
*/}}
{{- define "authelia.ingress.traefikCRD.existingTLSOption" -}}
{{- if and .Values.ingress.traefikCRD.tls.existingOptions -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Returns if we should create the TraefikCRD TLSOption
*/}}
{{- define "authelia.ingress.traefikCRD.createTLSOption" -}}
{{- if and .Values.ingress.traefikCRD.tls (include "authelia.ingress.traefikCRD.enabled" .) (not (include "authelia.ingress.traefikCRD.existingTLSOption" .)) -}}
    {{- true -}}
{{- end -}}
{{- end -}}


{{/*
Returns the common labels
*/}}
{{- define "authelia.labels" -}}
{{ include "authelia.matchLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ include "authelia.chart" . }}
{{- if .Values.extraLabels }}
{{ toYaml .Values.extraLabels }}
{{- end }}
{{- end -}}

{{/*
Returns the match labels
*/}}
{{- define "authelia.matchLabels" -}}
app.kubernetes.io/name: {{ .Values.appNameOverride | default .Chart.Name | trunc 63 | trimSuffix "-" }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Returns the common annotations
*/}}
{{- define "authelia.annotations" -}}
{{- if .Values.extraAnnotations -}}
{{ toYaml .Values.extraAnnotations }}
{{- end }}
{{- end -}}


{{/*
Returns the jwt token or a randomly generated one
*/}}
{{- define "authelia.jwtToken" -}}
{{- if .Values.secret.jwt.value -}}
    {{- .Values.secret.jwt.value | b64enc -}}
{{- else -}}
    {{- randAlphaNum 128 | b64enc -}}
{{- end -}}
{{- end -}}

{{/*
Returns the session encryption key or a randomly generated one
*/}}
{{- define "authelia.sessionEncryptionKey" -}}
{{- if .Values.secret.session.value -}}
    {{- .Values.secret.session.value | b64enc -}}
{{- else -}}
    {{- randAlphaNum 128 | b64enc -}}
{{- end -}}
{{- end -}}

{{/*
Returns the ldap password or a randomly generated one
*/}}
{{- define "authelia.ldapPassword" -}}
{{- if .Values.secret.ldap.value -}}
    {{- .Values.secret.ldap.value | b64enc -}}
{{- else -}}
    {{- randAlphaNum 128 | b64enc -}}
{{- end -}}
{{- end -}}

{{/*
Returns the storage password or a randomly generated one
*/}}
{{- define "authelia.storagePassword" -}}
{{- if .Values.secret.storage.value -}}
    {{- .Values.secret.storage.value | b64enc -}}
{{- else -}}
    {{- randAlphaNum 128 | b64enc -}}
{{- end -}}
{{- end -}}

{{/*
Returns the redis password or a randomly generated one
*/}}
{{- define "authelia.redisPassword" -}}
{{- if .Values.secret.redis.value -}}
    {{- .Values.secret.redis.value | b64enc -}}
{{- else -}}
    {{- randAlphaNum 128 | b64enc -}}
{{- end -}}
{{- end -}}

{{/*
Returns the smtp password or a randomly generated one
*/}}
{{- define "authelia.smtpPassword" -}}
{{- if .Values.secret.smtp.value -}}
    {{- .Values.secret.smtp.value | b64enc -}}
{{- else -}}
    {{- randAlphaNum 128 | b64enc -}}
{{- end -}}
{{- end -}}

{{/*
Returns the smtp password or a randomly generated one
*/}}
{{- define "authelia.deploymentStrategy" -}}
    {{- if .Values.deployment.strategy -}}
        {{- if .Values.deployment.strategy.type -}}
            {{- if .Values.deployment.useDaemonSet -}}
                {{- if or (eq .Values.deployment.strategy.type "RollingUpdate") (eq .Values.deployment.strategy.type "OnDelete") -}}
                    {{- .Values.deployment.strategy.type -}}
                {{- else -}}
                    {{- "RollingUpdate" -}}
                {{- end -}}
            {{- else -}}
                {{- if or (eq .Values.deployment.strategy.type "RollingUpdate") (eq .Values.deployment.strategy.type "Recreate") -}}
                    {{- .Values.deployment.strategy.type -}}
                {{- else -}}
                    {{- "RollingUpdate" -}}
                {{- end -}}
            {{- end -}}
        {{- end -}}
    {{- else -}}
        {{- "RollingUpdate" -}}
    {{- end -}}
{{- end -}}

{{/*
Returns the ingress hostname
*/}}
{{- define "authelia.ingressHost" -}}
    {{- printf "%s.%s" (default "auth" .Values.ingress.subdomain) .Values.configMap.domain -}}
{{- end -}}

{{/*
Returns the ingress hostname with the path
*/}}
{{- define "authelia.ingressHostWithPath" -}}
    {{- printf "%s%s" (include "authelia.ingressHost" . ) (default "/" .Values.configMap.path) -}}
{{- end -}}


{{/*
Returns applicable Deployment API version
*/}}
{{- define "capabilities.apiVersion.deployment" -}}
{{- if .Capabilities.APIVersions.Has "apps/v1/Deployment" -}}
{{- print "apps/v1" -}}
{{- else if .Capabilities.APIVersions.Has "apps/v1beta2/Deployment" -}}
{{- print "apps/v1beta2" -}}
{{- else if .Capabilities.APIVersions.Has "apps/v1beta1/Deployment" -}}
{{- print "apps/v1beta1" -}}
{{- else if .Capabilities.APIVersions.Has "extensions/v1beta1" -}}
{{- print "extensions/v1beta1" -}}
{{- else -}}
{{- print "apps/v1" -}}
{{- end }}
{{- end -}}

{{/*
Returns applicable DaemonSet API version
*/}}
{{- define "capabilities.apiVersion.daemonSet" -}}
{{- if .Capabilities.APIVersions.Has "apps/v1/DaemonSet" -}}
{{- print "apps/v1" -}}
{{- else if .Capabilities.APIVersions.Has "apps/v1beta2/DaemonSet" -}}
{{- print "apps/v1beta2" -}}
{{- else if .Capabilities.APIVersions.Has "apps/v1beta1/DaemonSet" -}}
{{- print "apps/v1beta1" -}}
{{- else if .Capabilities.APIVersions.Has "extensions/v1beta1" -}}
{{- print "extensions/v1beta1" -}}
{{- else -}}
{{- print "apps/v1" -}}
{{- end }}
{{- end -}}

{{/*
Returns applicable Ingress API version
*/}}
{{- define "capabilities.apiVersion.ingress" -}}
{{- if .Capabilities.APIVersions.Has "networking.k8s.io/v1/Ingress" -}}
{{- print "networking.k8s.io/v1" -}}
{{- else if .Capabilities.APIVersions.Has "networking.k8s.io/v1beta1/Ingress" -}}
{{- print "networking.k8s.io/v1beta1" -}}
{{- else if .Capabilities.APIVersions.Has "extensions/v1beta1" -}}
{{- print "extensions/v1beta1" -}}
{{- else -}}
{{- print "networking.k8s.io/v1" -}}
{{- end }}
{{- end -}}