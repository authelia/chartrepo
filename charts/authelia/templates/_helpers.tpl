{{/*
Return the proper image name
*/}}
{{- define "authelia.image" -}}
    {{- $registryName := default "docker.io" .Values.image.registry -}}
    {{- $repositoryName := default "authelia/authelia" .Values.image.repository -}}
    {{- $tag := default "latest" .Values.image.tag | toString -}}
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
Returns the name of the forwardAuth Middleware for forward auth which gets applied to other IngressRoutes.
*/}}
{{- define "authelia.ingress.traefikCRD.middleware.name.forwardAuth" -}}
    {{- if .Values.ingress.traefikCRD.middlewares.auth.nameOverride -}}
        {{- .Values.ingress.traefikCRD.middlewares.auth.nameOverride -}}
    {{- else -}}
        {{- printf "forwardauth-%s" (include "authelia.name" .) -}}
    {{- end -}}
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
Returns true if smtp is enabled.
*/}}
{{- define "authelia.configured.smtp" -}}
    {{- if .Values.configMap -}}
        {{- if .Values.configMap.notifier -}}
            {{- if .Values.configMap.notifier.smtp -}}
                {{- if .Values.configMap.notifier.smtp.enabled -}}
                    {{- true -}}
                {{- end -}}
            {{- end -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Returns true if smtp secret is configured.
*/}}
{{- define "authelia.configured.smtpSecret" -}}
    {{- if .Values.secret -}}
        {{- if .Values.secret.smtp -}}
            {{- if hasKey .Values.secret.smtp "value" -}}
                {{- true -}}
            {{- end -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Returns true if duo is enabled.
*/}}
{{- define "authelia.configured.duo" -}}
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
{{- define "authelia.configured.duoSecret" -}}
    {{- if .Values.secret -}}
        {{- if .Values.secret.duo -}}
            {{- if hasKey .Values.secret.duo "value" -}}
                {{- true -}}
            {{- end -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Returns the name of the chain Middleware for forward auth which gets applied to other IngressRoutes.
*/}}
{{- define "authelia.ingress.traefikCRD.middleware.name.chainAuth" -}}
    {{- if .Values.ingress.traefikCRD.middlewares.chains.auth.nameOverride -}}
        {{- .Values.ingress.traefikCRD.middlewares.chains.auth.nameOverride -}}
    {{- else -}}
        {{- printf "chain-%s-auth" (include "authelia.name" .) -}}
    {{- end -}}
{{- end -}}

{{/*
Returns the name of the chain Middleware for forward auth which gets applied to other IngressRoutes.
*/}}
{{- define "authelia.ingress.traefikCRD.middleware.name.chainIngress" -}}
    {{- printf "chain-%s" (include "authelia.name" .) -}}
{{- end -}}

{{/*
Special Annotations Generator for the Ingress kind.
*/}}
{{- define "authelia.ingress.annotations" -}}
  {{- $annotations := dict -}}
  {{- $annotations = mergeOverwrite $annotations .Values.ingress.annotations -}}
  {{- if .Values.ingress.certManager -}}
  {{- $annotations = set $annotations "kubernetes.io/tls-acme" "true" -}}
  {{- end -}}
  {{ include "authelia.annotations" (merge (dict "Annotations" $annotations) .) }}
{{- end -}}

{{/*
Returns if we should use existing TraefikCRD TLSOption
*/}}
{{- define "authelia.existing.ingress.traefik.tlsOption" -}}
    {{- if .Values.ingress.traefikCRD.tls -}}
        {{- if .Values.ingress.traefikCRD.tls.existingOptions -}}
            {{- true -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Returns the common labels
*/}}
{{- define "authelia.labels" -}}
    {{ include "authelia.matchLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ include "authelia.chart" . }}
    {{- if .Values.extraLabels }}
        {{ toYaml .Values.extraLabels }}
    {{- end }}
    {{- if .Labels }}
        {{ toYaml .Labels }}
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
        {{ toYaml .Values.extraAnnotations | indent 0 }}
    {{- end }}
    {{- if .Annotations -}}
        {{ toYaml .Annotations | indent 0 }}
    {{- end }}
{{- end -}}

{{/*
Returns the injector annotations
*/}}
{{- define "authelia.annotations.injector" -}}
    {{- if include "authelia.enabled.injector" . -}}
vault.hashicorp.com/role: {{ default "authelia" .Values.secret.vault_injector.role }}
vault.hashicorp.com/agent-inject: "true"
vault.hashicorp.com/agent-inject-status: {{ default "update" .Values.secret.vault_injector.status }}
{{- if .Values.secret.vault_injector.command }}
vault.hashicorp.com/agent-inject-command: {{ .Values.secret.vault_injector.command }}
{{- end }}
{{- if .Values.secret.vault_injector.templateValue }}
vault.hashicorp.com/agent-inject-template: {{ .Values.secret.vault_injector.templateValue }}
{{- end }}
vault.hashicorp.com/agent-inject-secret-JWT_TOKEN: {{ .Values.secret.vault_injector.secrets.jwt.path }}
{{- if .Values.secret.vault_injector.secrets.jwt.templateValue }}
vault.hashicorp.com/agent-inject-secret-template-JWT_TOKEN: {{ .Values.secret.vault_injector.secrets.jwt.templateValue }}
{{- end }}
{{- if .Values.secret.vault_injector.secrets.jwt.command }}
vault.hashicorp.com/agent-inject-secret-command-JWT_TOKEN: {{ .Values.secret.vault_injector.secrets.jwt.command }}
{{- end }}
vault.hashicorp.com/agent-inject-secret-SESSION_ENCRYPTION_KEY: {{ .Values.secret.vault_injector.secrets.session.path }}
{{- if .Values.secret.vault_injector.secrets.session.templateValue }}
vault.hashicorp.com/agent-inject-secret-template-SESSION_ENCRYPTION_KEY: {{ .Values.secret.vault_injector.secrets.session.templateValue }}
{{- end }}
{{- if .Values.secret.vault_injector.secrets.session.command }}
vault.hashicorp.com/agent-inject-secret-command-SESSION_ENCRYPTION_KEY: {{ .Values.secret.vault_injector.secrets.session.command }}
{{- end }}
{{- if .Values.configMap.authentication_backend.ldap.enabled }}
vault.hashicorp.com/agent-inject-secret-LDAP_PASSWORD: {{ .Values.secret.vault_injector.secrets.ldap.path }}
{{- if .Values.secret.vault_injector.secrets.ldap.templateValue }}
vault.hashicorp.com/agent-inject-secret-template-LDAP_PASSWORD: {{ .Values.secret.vault_injector.secrets.ldap.templateValue }}
{{- end }}
{{- if .Values.secret.vault_injector.secrets.ldap.command }}
vault.hashicorp.com/agent-inject-secret-command-LDAP_PASSWORD: {{ .Values.secret.vault_injector.secrets.ldap.command }}
{{- end }}
{{- end }}
{{- if or .Values.configMap.storage.mysql.enabled .Values.configMap.storage.postgres.enabled }}
vault.hashicorp.com/agent-inject-secret-STORAGE_PASSWORD: {{ .Values.secret.vault_injector.secrets.storage.path }}
{{- if .Values.secret.vault_injector.secrets.storage.templateValue }}
vault.hashicorp.com/agent-inject-secret-template-STORAGE_PASSWORD: {{ .Values.secret.vault_injector.secrets.storage.templateValue }}
{{- end }}
{{- if .Values.secret.vault_injector.secrets.storage.command }}
vault.hashicorp.com/agent-inject-secret-command-STORAGE_PASSWORD: {{ .Values.secret.vault_injector.secrets.storage.command }}
{{- end }}
{{- end }}
{{- if and .Values.configMap.session.redis.enabled .Values.configMap.session.redis.enabledSecret }}
vault.hashicorp.com/agent-inject-secret-REDIS_PASSWORD: {{ .Values.secret.vault_injector.secrets.redis.path }}
{{- if .Values.secret.vault_injector.secrets.redis.templateValue }}
vault.hashicorp.com/agent-inject-secret-template-REDIS_PASSWORD: {{ .Values.secret.vault_injector.secrets.redis.templateValue }}
{{- end }}
{{- if .Values.secret.vault_injector.secrets.redis.command }}
vault.hashicorp.com/agent-inject-secret-command-REDIS_PASSWORD: {{ .Values.secret.vault_injector.secrets.redis.command }}
{{- end }}
{{- if and .Values.configMap.session.redis.high_availability.enabled .Values.configMap.session.redis.high_availability.enabledSecret }}
vault.hashicorp.com/agent-inject-secret-REDIS_SENTINEL_PASSWORD: {{ .Values.secret.vault_injector.secrets.redis_sentinel.path }}
{{- if .Values.secret.vault_injector.secrets.redis_sentinel.templateValue }}
vault.hashicorp.com/agent-inject-secret-template-REDIS_SENTINEL_PASSWORD: {{ .Values.secret.vault_injector.secrets.redis_sentinel.templateValue }}
{{- end }}
{{- if .Values.secret.vault_injector.secrets.redis_sentinel.command }}
vault.hashicorp.com/agent-inject-secret-command-REDIS_SENTINEL_PASSWORD: {{ .Values.secret.vault_injector.secrets.redis_sentinel.command }}
{{- end }}
{{- end }}
{{- end }}
{{- if and .Values.configMap.notifier.smtp.enabled .Values.configMap.notifier.smtp.enabledSecret }}
vault.hashicorp.com/agent-inject-secret-SMTP_PASSWORD: {{ .Values.secret.vault_injector.secrets.smtp.path }}
{{- if .Values.secret.vault_injector.secrets.smtp.templateValue }}
vault.hashicorp.com/agent-inject-secret-template-SMTP_PASSWORD: {{ .Values.secret.vault_injector.secrets.smtp.templateValue }}
{{- end }}
{{- if .Values.secret.vault_injector.secrets.smtp.command }}
vault.hashicorp.com/agent-inject-secret-command-SMTP_PASSWORD: {{ .Values.secret.vault_injector.secrets.smtp.command }}
{{- end }}
{{- end }}
{{- if include "authelia.configured.duo" . }}
vault.hashicorp.com/agent-inject-secret-DUO_API_KEY: {{ .Values.secret.vault_injector.secrets.duo.path }}
{{- if .Values.secret.vault_injector.secrets.duo.templateValue }}
vault.hashicorp.com/agent-inject-secret-template-DUO_API_KEY: {{ .Values.secret.vault_injector.secrets.duo.templateValue }}
{{- end }}
{{- if .Values.secret.vault_injector.secrets.duo.command }}
vault.hashicorp.com/agent-inject-secret-command-DUO_API_KEY: {{ .Values.secret.vault_injector.secrets.duo.command }}
{{- end }}
{{- end }}
vault.hashicorp.com/agent-run-as-same-user: {{ default "true" .Values.secret.vault_injector.sameAsUser | quote }}
{{- toYaml .Values.secret.annotations | nindent 0 }}
    {{- end }}
{{- end -}}

{{/*
Returns the value of .SecretValue or a randomly generated one
*/}}
{{- define "authelia.secret.standard" -}}
    {{- if .SecretValue -}}
        {{- .SecretValue | b64enc -}}
    {{- else -}}
        {{- randAlphaNum 128 | b64enc -}}
    {{- end -}}
{{- end -}}

{{/*
Returns the correct secret path for env.
*/}}
{{- define "authelia.secret.path" -}}
    {{- if include "authelia.enabled.injector" . -}}
        {{- printf "/vault/secrets/%s" .Name -}}
    {{- else -}}
        {{- printf "/config/secrets/%s" .Name -}}
    {{- end -}}
{{- end -}}

{{/*
Returns the kind for the pod.
*/}}
{{- define "authelia.pod.kind" -}}
    {{- if not .Values.pod.kind -}}
        {{- if (include "authelia.stateful" .) -}}
            {{- "StatefulSet" -}}
        {{- else -}}
            {{- "DaemonSet" -}}
        {{- end -}}
    {{- else if eq "daemonset" (.Values.pod.kind | lower) -}}
        {{- "DaemonSet" -}}
    {{- else if eq "statefulset" (.Values.pod.kind | lower) -}}
        {{- "StatefulSet" -}}
    {{- else if eq "deployment" (.Values.pod.kind | lower) -}}
        {{- "Deployment" -}}
    {{- else }}
        {{- if (include "authelia.stateful" .) -}}
            {{- "StatefulSet" -}}
        {{- else -}}
            {{- "DaemonSet" -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Returns the smtp password or a randomly generated one
*/}}
{{- define "authelia.deploymentStrategy" -}}
    {{- if .Values.pod.strategy -}}
        {{- if .Values.pod.strategy.type -}}
            {{- if eq "DaemonSet" (include "authelia.pod.kind" .) -}}
                {{- if or (eq .Values.pod.strategy.type "RollingUpdate") (eq .Values.pod.strategy.type "OnDelete") -}}
                    {{- .Values.pod.strategy.type -}}
                {{- else -}}
                    {{- "RollingUpdate" -}}
                {{- end -}}
            {{- else -}}
                {{- if or (eq .Values.pod.strategy.type "RollingUpdate") (eq .Values.pod.strategy.type "Recreate") -}}
                    {{- .Values.pod.strategy.type -}}
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
    {{- if .Values.ingress.subdomain -}}
        {{- printf "%s.%s" (default "auth" .Values.ingress.subdomain) .Values.domain -}}
    {{- else -}}
        {{- .Values.domain -}}
    {{- end -}}
{{- end -}}

{{/*
Returns the ingress hostname with the path
*/}}
{{- define "authelia.ingressHostWithPath" -}}
    {{- printf "%s%s" (include "authelia.ingressHost" .) (include "authelia.path" . | trimSuffix "/") -}}
{{- end -}}

{{/*
Returns the forwardAuth url
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
    {{- $redirect := (include "authelia.ingressHostWithPath" .) -}}
    {{- (printf "%s://%s.svc.%s%s/api/verify?rd=https://%s/#/" $scheme $host $cluster $path $redirect) -}}
{{- end -}}

{{/*
Returns applicable Deployment/DaemonSet/Ingress API Version
*/}}
{{- define "capabilities.apiVersion.kind" -}}
    {{- if eq "DaemonSet" (default "DaemonSet" .Kind) -}}
        {{- include "capabilities.apiVersion.daemonSet" . -}}
    {{- else if eq "Ingress" .Kind -}}
        {{- include "capabilities.apiVersion.ingress" . -}}
    {{- else if eq "StatefulSet" .Kind -}}
        {{- include "capabilities.apiVersion.statefulSet" . -}}
    {{- else -}}
        {{- include "capabilities.apiVersion.deployment" . -}}
    {{- end -}}
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
    {{- else -}}
        {{- print "apps/v1" -}}
    {{- end }}
{{- end -}}

{{/*
Returns applicable StatefulSet API version
*/}}
{{- define "capabilities.apiVersion.statefulSet" -}}
    {{- if .Capabilities.APIVersions.Has "apps/v1/StatefulSet" -}}
        {{- print "apps/v1" -}}
    {{- else if .Capabilities.APIVersions.Has "apps/v1beta2/StatefulSet" -}}
        {{- print "apps/v1beta2" -}}
    {{- else if .Capabilities.APIVersions.Has "apps/v1beta1/StatefulSet" -}}
        {{- print "apps/v1beta1" -}}
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
    {{- else -}}
        {{- print "networking.k8s.io/v1" -}}
    {{- end }}
{{- end -}}

{{/*
Returns true if we should generate a ConfigMap.
*/}}
{{- define "authelia.generate.configMap" -}}
    {{- if include "authelia.enabled.configMap" . -}}
        {{- if not .Values.configMap.existingConfigMap -}}
            {{- true -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Returns true if we should use a ConfigMap.
*/}}
{{- define "authelia.enabled.configMap" -}}
    {{- if .Values.configMap -}}
        {{- if .Values.configMap.enabled -}}
            {{- true -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Returns true if we should use a PDB.
*/}}
{{- define "authelia.enabled.podDisruptionBudget" -}}
    {{- if .Values.podDisruptionBudget -}}
        {{- if .Values.podDisruptionBudget.enabled -}}
            {{- true -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Returns if hashicorp injector is enabled
*/}}
{{- define "authelia.enabled.injector" -}}
    {{- if .Values.secret -}}
        {{- if .Values.secret.vault_injector -}}
            {{- if .Values.secret.vault_injector.enabled -}}
                {{- true -}}
            {{- end -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Returns if we should generate the secret
*/}}
{{- define "authelia.enabled.secret" -}}
    {{- if .Values.secret -}}
        {{- if not (include "authelia.enabled.injector" .) }}
            {{- if not .Values.secret.existingSecret -}}
                {{- true -}}
            {{- else if eq "" .Values.secret.existingSecret -}}
                {{- true -}}
            {{- end -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Returns if we should generate the secret for certificates
*/}}
{{- define "authelia.generate.certificatesSecret" -}}
    {{- if .Values.certificates -}}
        {{- if .Values.certificates.values -}}
            {{- if not .Values.certificates.existingSecret -}}
                {{- true -}}
            {{- else if eq "" .Values.certificates.existingSecret -}}
                {{- true -}}
            {{- end -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Returns if we should generate the secret for certificates
*/}}
{{- define "authelia.enabled.certificatesSecret" -}}
    {{- if .Values.certificates -}}
        {{- if .Values.certificates.values -}}
            {{- true -}}
        {{- else if .Values.certificates.existingSecret -}}
            {{- true -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Returns if we should generate the secret for certificates
*/}}
{{- define "authelia.names.certificatesSecret" -}}
    {{- if .Values.certificates -}}
        {{- if .Values.certificates.existingSecret -}}
            {{- .Values.certificates.existingSecret -}}
        {{- else -}}
            {{- printf "%s-certificates" (include "authelia.name" .) -}}
        {{- end -}}
    {{- else -}}
        {{- printf "%s-certificates" (include "authelia.name" .) -}}
    {{- end -}}
{{- end -}}

{{/*
Returns if we should generate the NetworkPolicy.
*/}}
{{- define "authelia.enabled.networkPolicy" -}}
    {{- if .Values.networkPolicy -}}
        {{- if .Values.networkPolicy.enabled -}}
            {{- true -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Returns if we should generate the PersistentVolumeClaim.
*/}}
{{- define "authelia.generate.persistentVolumeClaim" -}}
    {{- if include "authelia.enabled.persistentVolumeClaim" . -}}
        {{- if not .Values.persistence.existingClaim -}}
            {{- true -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Returns if we should generate the PersistentVolumeClaim.
*/}}
{{- define "authelia.enabled.persistentVolumeClaim" -}}
    {{- if .Values.persistence -}}
        {{- if .Values.persistence.enabled -}}
            {{- true -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Returns true if generation of an ingress is enabled.
*/}}
{{- define "authelia.enabled.ingress" -}}
    {{- if .Values.ingress -}}
        {{- if .Values.ingress.enabled -}}
            {{- true -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Returns true if generation of an IngressRoute is enabled.
*/}}
{{- define "authelia.enabled.ingress.traefik" -}}
    {{- if (include "authelia.enabled.ingress" .) -}}
        {{- if .Values.ingress.traefikCRD -}}
            {{- if .Values.ingress.traefikCRD.enabled -}}
                {{- true -}}
            {{- end -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Returns if we should use existing TraefikCRD TLSOption
*/}}
{{- define "authelia.enabled.ingress.traefik.tlsOption" -}}
    {{- if (include "authelia.enabled.ingress.traefik" .) -}}
        {{- if .Values.ingress.traefikCRD.tls -}}
            {{- if .Values.ingress.traefikCRD.tls.options -}}
                {{- if not (include "authelia.existing.ingress.traefik.tlsOption" .) -}}
                    {{- true -}}
                {{- end -}}
            {{- end -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Returns true if generation of an Ingress is enabled.
*/}}
{{- define "authelia.enabled.ingress.standard" -}}
    {{- if and (include "authelia.enabled.ingress" .) (not (include "authelia.enabled.ingress.traefik" .)) -}}
        {{- true -}}
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