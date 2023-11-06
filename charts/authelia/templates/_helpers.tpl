{{/*
Return the proper image name
*/}}
{{- define "authelia.image" -}}
    {{- $registryName := default "docker.io" .Values.image.registry -}}
    {{- $repositoryName := default "authelia/authelia" .Values.image.repository -}}
    {{- $tag := .Values.image.tag | default .Chart.AppVersion  | toString -}}
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
Return the app version.
*/}}
{{- define "authelia.version" -}}
    {{ .Values.versionOverride | default .Chart.AppVersion | toString }}
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
                {{- if not (eq .Values.secret.duo.value "") -}}
                    {{- true -}}
                {{- end -}}
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
  {{- if and .Values.ingress.traefikCRD .Values.ingress.traefikCRD.disableIngressRoute -}}
  {{- if and (gt (len .Values.ingress.traefikCRD.entryPoints) 0) (not (hasKey $annotations "traefik.ingress.kubernetes.io/router.entryPoints")) -}}
  {{- $annotations = set $annotations "traefik.ingress.kubernetes.io/router.entryPoints" (.Values.ingress.traefikCRD.entryPoints | join ",") -}}
  {{- end -}}
  {{- if not (hasKey $annotations "traefik.ingress.kubernetes.io/router.middlewares") }}
  {{- $annotations = set $annotations "traefik.ingress.kubernetes.io/router.middlewares" (printf "%s-%s@kubernetescrd" .Release.Namespace (include "authelia.ingress.traefikCRD.middleware.name.chainIngress" .)) -}}
  {{- end }}
  {{- end -}}
  {{ include "authelia.annotations" (merge (dict "Annotations" $annotations) .) }}
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
app.kubernetes.io/version: {{ include "authelia.version" . }}
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
{{- define "authelia.matchLabels" -}}
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
Returns the value of .SecretValue or a randomly generated one
*/}}
{{- define "authelia.secret.standard" -}}
    {{- if and .SecretValue (not (eq .SecretValue "")) -}}
        {{- .SecretValue | b64enc -}}
    {{- else if and .LookupValue -}}
        {{- if (not (eq .LookupValue "")) -}}
            {{- .LookupValue -}}
        {{- else -}}
            {{- randAlphaNum 128 | b64enc -}}
        {{- end -}}
    {{- else -}}
        {{- randAlphaNum 128 | b64enc -}}
    {{- end -}}
{{- end -}}

{{/*
Returns the mountPath of the secrets.
*/}}
{{- define "authelia.secret.mountPath" -}}
    {{- default "/secrets" .Values.secret.mountPath -}}
{{- end -}}

{{- define "authelia.secret.path" -}}
    {{- if eq .Secret "jwt" -}}
        {{- default "JWT_TOKEN" .Values.secret.jwt.filename -}}
    {{- else if eq .Secret "storage" -}}
        {{- default "STORAGE_PASSWORD" .Values.secret.storage.filename -}}
    {{- else if eq .Secret "storageEncryptionKey" -}}
        {{- default "STORAGE_ENCRYPTION_KEY" .Values.secret.storageEncryptionKey.filename -}}
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
        {{- default "REDIS_SENTINEL_PASSWORD" .Values.secret.redisSentinel.filename -}}
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
Returns the rollingUpdate spec
*/}}
{{- define "authelia.rollingUpdate" -}}
    {{- $result := dict -}}
    {{- if eq "StatefulSet" (include "authelia.pod.kind" .) -}}
        {{ $result = dict "partition" 0 }}
        {{- if .Values.pod.strategy -}}
            {{- if .Values.pod.strategy.rollingUpdate -}}
                {{- $_ := set $result "partition" (default 0 .Values.pod.strategy.rollingUpdate.partition) -}}
            {{- end -}}
        {{- end -}}
    {{- else if eq "DaemonSet" (include "authelia.pod.kind" .) -}}
        {{ $result = dict "maxUnavailable" "25%" }}
        {{- if .Values.pod.strategy -}}
            {{- if .Values.pod.strategy.rollingUpdate -}}
                {{- $_ := set $result "maxUnavailable" (default "25%" .Values.pod.strategy.rollingUpdate.maxUnavailable) -}}
            {{- end -}}
        {{- end -}}
    {{- else -}}
        {{ $result = dict "maxSurge" "25%" "maxUnavailable" "25%" }}
        {{- if .Values.pod.strategy -}}
            {{- if .Values.pod.strategy.rollingUpdate -}}
                {{- $_ := set $result "maxSurge" (default "25%" .Values.pod.strategy.rollingUpdate.maxSurge) "maxUnavailable" (default "25%" .Values.pod.strategy.rollingUpdate.maxUnavailable) -}}
            {{- end -}}
        {{- end -}}
    {{- end -}}
    {{ toYaml $result | indent 0 }}
{{- end -}}

{{/*
Returns the number of replicas
*/}}
{{- define "authelia.replicas" -}}
      {{- if (include "authelia.stateful" .) }}
        {{- 1 -}}
      {{- else -}}
        {{- default 1 .Values.pod.replicas -}}
      {{- end -}}
{{- end -}}

{{/*
Returns the pod management policy
*/}}
{{- define "authelia.podManagementPolicy" -}}
      {{- if (include "authelia.stateful" .) }}
        {{- "Parallel" -}}
      {{- else -}}
        {{- default "Parallel" .Values.pod.managementPolicy -}}
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
Returns true if we should use the ACL Secret.
*/}}
{{- define "authelia.enabled.acl.secret" -}}
    {{- if hasKey .Values "configMap" -}}
        {{- if .Values.configMap.enabled -}}
            {{- if .Values.configMap.access_control.secret.enabled }}
                {{- true -}}
            {{- end -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Returns true if we should use a mount the ACL Secret.
*/}}
{{- define "authelia.mount.acl.secret" -}}
    {{- if or (include "authelia.enabled.acl.secret" .) .Values.configMap.access_control.secret.existingSecret -}}
        {{- true -}}
    {{- end -}}
{{- end -}}

{{/*
Returns true if we should use a generate the ACL Secret.
*/}}
{{- define "authelia.generate.acl.secret" -}}
    {{- if and (include "authelia.enabled.acl.secret" .) (not .Values.configMap.access_control.secret.existingSecret) -}}
        {{- true -}}
    {{- end -}}
{{- end -}}

{{/*
Returns the ACL secret name.
*/}}
{{- define "authelia.name.acl.secret" -}}
    {{- default (printf "%s-acl" (include "authelia.name" .) | trunc 63 | trimSuffix "-") .Values.configMap.access_control.secret.existingSecret -}}
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
Returns if we should generate the secret
*/}}
{{- define "authelia.enabled.secret" -}}
    {{- if .Values.secret -}}
        {{- if not .Values.secret.existingSecret -}}
            {{- true -}}
        {{- else if eq "" .Values.secret.existingSecret -}}
            {{- true -}}
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
Returns true if generation of the TraefikCRD resources is enabled.
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
Returns true if generation of an Ingress is enabled.
*/}}
{{- define "authelia.enabled.ingress.ingress" -}}
    {{- if .Values.ingress.enabled -}}
        {{- if or (not (include "authelia.enabled.ingress.traefik" .)) (.Values.ingress.traefikCRD.disableIngressRoute) -}}
            {{- true -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Returns true if generation of an IngressRoute is enabled.
*/}}
{{- define "authelia.enabled.ingress.ingressRoute" -}}
    {{- if and (include "authelia.enabled.ingress.traefik" .) (not .Values.ingress.traefikCRD.disableIngressRoute) -}}
        {{- true -}}
    {{- end -}}
{{- end -}}

{{/*
Returns if we should use existing TraefikCRD TLSOption
*/}}
{{- define "authelia.enabled.ingress.traefik.tlsOption" -}}
    {{- if .Values.ingress.tls.enabled -}}
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
        {{- if .Values.configMap.server.path -}}
            {{- printf "/%s" .Values.configMap.server.path -}}
        {{- else -}}
            {{- "/" -}}
        {{- end -}}
    {{- else -}}
        {{- "/" -}}
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
{{- define "authelia.squote.join" -}}
{{- if kindIs "string" . }}{{ . | squote }}
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
squote a list joined by comma
*/}}
{{- define "authelia.squote.list" -}}
{{- range . }}
- {{ . | squote }}
{{- end }}
{{- end -}}

{{/*
Returns the password reset disabled value.
*/}}
{{- define "authelia.config.password_reset.disable" -}}
{{- if hasKey .Values.configMap.authentication_backend "disable_reset_password" }}
{{- .Values.configMap.authentication_backend.disable_reset_password }}
{{- else }}
{{- .Values.configMap.authentication_backend.password_reset.disable | default false }}
{{- end }}
{{- end -}}
