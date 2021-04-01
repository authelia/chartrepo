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
    {{- if .Values.labels }}
        {{ toYaml .Values.labels }}
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
    {{- if .Values.annotations -}}
        {{ toYaml .Values.annotations | indent 0 }}
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
    {{- with $vault := .Values.secret.vaultInjector -}}
vault.hashicorp.com/agent-inject: "true"
{{- if $vault.role }}
vault.hashicorp.com/role: {{ default "authelia" $vault.role }}
{{- end }}
{{- if $vault.agent.status }}
vault.hashicorp.com/agent-inject-status: {{ default "update" $vault.agent.status }}
{{- end }}
{{- if $vault.agent.configMap }}
vault.hashicorp.com/agent-configmap: {{ $vault.agent.configMap }}
{{- end }}
{{- if $vault.agent.image }}
vault.hashicorp.com/agent-image: {{ $vault.agent.image }}
{{- end }}
{{- if $vault.agent.initFirst }}
vault.hashicorp.com/agent-init-first: {{ $vault.agent.initFirst }}
{{- end }}
{{- if $vault.agent.command }}
vault.hashicorp.com/agent-inject-command: {{ $vault.agent.command }}
{{- end }}
vault.hashicorp.com/agent-inject-volume-path: {{ include "authelia.secret.mountPath" $ }}
vault.hashicorp.com/agent-inject-secret-jwt: {{ $vault.secrets.jwt.path }}
vault.hashicorp.com/agent-inject-file-jwt: {{ include "authelia.secret.path" (merge (dict "Secret" "jwt") $) }}
{{- if or $vault.agent.templateValue $vault.secrets.jwt.templateValue }}
vault.hashicorp.com/agent-inject-template-jwt: {{ default $vault.agent.templateValue $vault.secrets.jwt.templateValue }}
{{- end }}
{{- if $vault.secrets.jwt.command }}
vault.hashicorp.com/agent-inject-secret-command-jwt: {{ $vault.secrets.jwt.command }}
{{- end }}
vault.hashicorp.com/agent-inject-secret-session: {{ $vault.secrets.session.path }}
vault.hashicorp.com/agent-inject-file-session: {{ include "authelia.secret.path" (merge (dict "Secret" "session") $) }}
{{- if or $vault.agent.templateValue $vault.secrets.session.templateValue }}
vault.hashicorp.com/agent-inject-template-session: {{ default $vault.agent.templateValue $vault.secrets.session.templateValue }}
{{- end }}
{{- if $vault.secrets.session.command }}
vault.hashicorp.com/agent-inject-secret-command-session: {{ $vault.secrets.session.command }}
{{- end }}
{{- if $.Values.configMap.authentication_backend.ldap.enabled }}
vault.hashicorp.com/agent-inject-secret-ldap: {{ $vault.secrets.ldap.path }}
vault.hashicorp.com/agent-inject-file-ldap: {{ include "authelia.secret.path" (merge (dict "Secret" "ldap") $) }}
{{- if or $vault.secrets.ldap.templateValue $vault.agent.templateValue }}
vault.hashicorp.com/agent-inject-template-ldap: {{ default $vault.agent.templateValue $vault.secrets.ldap.templateValue }}
{{- end }}
{{- if $vault.secrets.ldap.command }}
vault.hashicorp.com/agent-inject-secret-command-ldap: {{ $vault.secrets.ldap.command }}
{{- end }}
{{- end }}
{{- if or $.Values.configMap.storage.mysql.enabled $.Values.configMap.storage.postgres.enabled }}
vault.hashicorp.com/agent-inject-secret-storage: {{ $vault.secrets.storage.path }}
vault.hashicorp.com/agent-inject-file-storage: {{ include "authelia.secret.path" (merge (dict "Secret" "storage") $) }}
{{- if or $vault.agent.templateValue $vault.secrets.storage.templateValue }}
vault.hashicorp.com/agent-inject-template-storage: {{ default $vault.agent.templateValue $vault.secrets.storage.templateValue }}
{{- end }}
{{- if $vault.secrets.storage.command }}
vault.hashicorp.com/agent-inject-secret-command-storage: {{ $vault.secrets.storage.command }}
{{- end }}
{{- end }}
{{- if and $.Values.configMap.session.redis.enabled $.Values.configMap.session.redis.enabledSecret }}
vault.hashicorp.com/agent-inject-secret-redis: {{ $vault.secrets.redis.path }}
vault.hashicorp.com/agent-inject-file-redis: {{ include "authelia.secret.path" (merge (dict "Secret" "redis") $) }}
{{- if or $vault.agent.templateValue $vault.secrets.redis.templateValue }}
vault.hashicorp.com/agent-inject-template-redis: {{ default $vault.agent.templateValue $vault.secrets.redis.templateValue }}
{{- end }}
{{- if $vault.secrets.redis.command }}
vault.hashicorp.com/agent-inject-secret-command-redis: {{ $vault.secrets.redis.command }}
{{- end }}
{{- if and $.Values.configMap.session.redis.high_availability.enabled $.Values.configMap.session.redis.high_availability.enabledSecret }}
vault.hashicorp.com/agent-inject-secret-redis-sentinel: {{ $vault.secrets.redisSentinel.path }}
vault.hashicorp.com/agent-inject-file-redis-sentinel: {{ include "authelia.secret.path" (merge (dict "Secret" "redis-sentinel") $) }}
{{- if or $vault.agent.templateValue $vault.secrets.redisSentinel.templateValue }}
vault.hashicorp.com/agent-inject-template-redis-sentinel {{ default $vault.agent.templateValue $vault.secrets.redisSentinel.templateValue }}
{{- end }}
{{- if $vault.secrets.redisSentinel.command }}
vault.hashicorp.com/agent-inject-secret-command-redis-sentinel: {{ $vault.secrets.redisSentinel.command }}
{{- end }}
{{- end }}
{{- end }}
{{- if and $.Values.configMap.notifier.smtp.enabled $.Values.configMap.notifier.smtp.enabledSecret }}
vault.hashicorp.com/agent-inject-secret-smtp: {{ $vault.secrets.smtp.path }}
vault.hashicorp.com/agent-inject-file-smtp: {{ include "authelia.secret.path" (merge (dict "Secret" "smtp") $) }}
{{- if or $vault.agent.templateValue $vault.secrets.smtp.templateValue }}
vault.hashicorp.com/agent-inject-template-smtp: {{ default $vault.agent.templateValue $vault.secrets.smtp.templateValue }}
{{- end }}
{{- if $vault.secrets.smtp.command }}
vault.hashicorp.com/agent-inject-secret-command-smtp: {{ $vault.secrets.smtp.command }}
{{- end }}
{{- end }}
{{- if include "authelia.configured.duo" $ }}
vault.hashicorp.com/agent-inject-secret-duo: {{ $vault.secrets.duo.path }}
vault.hashicorp.com/agent-inject-file-duo: {{ include "authelia.secret.path" (merge (dict "Secret" "duo") $) }}
{{- if or $vault.agent.templateValue $vault.secrets.duo.templateValue }}
vault.hashicorp.com/agent-inject-template-duo: {{ default $vault.agent.templateValue $vault.secrets.duo.templateValue }}
{{- end }}
{{- if $vault.secrets.duo.command }}
vault.hashicorp.com/agent-inject-secret-command-duo: {{ $vault.secrets.duo.command }}
{{- end }}
{{- end }}
{{- if $.Values.configMap.identity_providers.oidc.enabled }}
vault.hashicorp.com/agent-inject-secret-oidc-private-key: {{ $vault.secrets.oidcPrivateKey.path }}
vault.hashicorp.com/agent-inject-file-oidc-private-key: {{ include "authelia.secret.path" (merge (dict "Secret" "oidc-private-key") $) }}
{{- if or $vault.agent.templateValue $vault.secrets.oidcPrivateKey.templateValue }}
vault.hashicorp.com/agent-inject-template-oidc-private-key: {{ default $vault.agent.templateValue $vault.secrets.oidcPrivateKey.templateValue }}
{{- end }}
{{- if $vault.secrets.oidcPrivateKey.command }}
vault.hashicorp.com/agent-inject-secret-command-oidc-private-key: {{ $vault.secrets.oidcPrivateKey.command }}
{{- end }}
vault.hashicorp.com/agent-inject-secret-oidc-hmac-secret: {{ $vault.secrets.oidcHMACSecret.path }}
vault.hashicorp.com/agent-inject-file-oidc-hmac-secret: {{ include "authelia.secret.path" (merge (dict "Secret" "oidc-hmac-secret") $) }}
{{- if or $vault.agent.templateValue $vault.secrets.oidcHMACSecret.templateValue }}
vault.hashicorp.com/agent-inject-template-oidc-hmac-secret: {{ default $vault.agent.templateValue $vault.secrets.oidcHMACSecret.templateValue }}
{{- end }}
{{- if $vault.secrets.oidcHMACSecret.command }}
vault.hashicorp.com/agent-inject-secret-command-oidc-hmac-secret: {{ $vault.secrets.oidcHMACSecret.command }}
{{- end }}
{{- end }}
vault.hashicorp.com/agent-run-as-same-user: {{ default "true" $vault.agent.runAsSameUser | quote }}
{{- if $.Values.secret.annotations }}
{{- toYaml $.Values.secret.annotations | nindent 0 }}
    {{- end }}
    {{- end }}
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
Returns the mountPath of the secrets.
*/}}
{{- define "authelia.secret.mountPath" -}}
    {{- default "/config/secrets" .Values.secret.mountPath -}}
{{- end -}}

{{- define "authelia.secret.path" -}}
    {{- if eq .Secret "jwt" -}}
        {{- default "JWT_TOKEN" .Values.secret.jwt.filename -}}
    {{- else if eq .Secret "storage" -}}
        {{- default "STORAGE_PASSWORD" .Values.secret.storage.filename -}}
    {{- else if eq .Secret "session" -}}
        {{- default "SESSION_ENCRYPTION_KEY" .Values.secret.session.filename -}}
    {{- else if eq .Secret "ldap" -}}
        {{- default "LDAP_PASSWORD" .Values.secret.ldap.filename -}}
    {{- else if eq .Secret "smtp" -}}
        {{- default "SMTP_PASSWORD" .Values.secret.smtp.filename -}}
    {{- else if eq .Secret "duo" -}}
        {{- default "DUO_API_KEY" .Values.secret.duo.filename -}}
    {{- else if eq .Secret "redis" -}}
        {{- default "REDIS_PASSWORD" .Values.secret.redis.filename -}}
    {{- else if eq .Secret "redis-sentinel" -}}
        {{- default "REDIS_SENTINEL_PASSWORD" .Values.secret.redis_sentinel.filename -}}
    {{- else if eq .Secret "oidc-private-key" -}}
        {{- default "OIDC_PRIVATE_KEY" .Values.secret.oidcPrivateKey.filename -}}
    {{- else if eq .Secret "oidc-hmac-secret" -}}
        {{- default "OIDC_HMAC_SECRET" .Values.secret.oidcHMACSecret.filename -}}
    {{- end -}}
{{- end -}}

{{- define "authelia.secret.fullPath" -}}
    {{- $path := (include "authelia.secret.mountPath" .) -}}
    {{- $filename := (include "authelia.secret.path" .) -}}
    {{- printf "%s/%s" $path $filename -}}
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
        {{- if .Values.secret.vaultInjector -}}
            {{- if .Values.secret.vaultInjector.enabled -}}
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
