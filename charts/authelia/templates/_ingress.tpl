{{- define "authelia.ingress.uri" -}}
    {{- if .Path }}
    {{- printf "https://%s/%s" (include "authelia.ingress.host" .) .Path }}
    {{- else }}
    {{- printf "https://%s" (include "authelia.ingress.host" .) }}
    {{- end }}
{{- end -}}

{{/*
    Returns the ingress host value.
*/}}
{{- define "authelia.ingress.host" -}}
    {{- if .SubDomain }}
    {{- printf "%s.%s" .SubDomain .Domain }}
    {{- else }}
    {{- .Domain }}
    {{- end }}
{{- end }}

{{/*
    Returns the forward auth URL.
*/}}
{{- define "authelia.ingress.traefikCRD.middleware.forwardAuth.address" -}}
    {{- $scheme := "http" -}}
    {{- $host := printf "%s.%s" (include "authelia.name" .) .Release.Namespace -}}
    {{- if .Namespace -}}
        {{- $host = printf "%s.%s" $host .Namespace -}}
    {{- end -}}
    {{- $path := (include "authelia.path" .) | trimSuffix "/" -}}
    {{- (printf "%s://%s.svc.%s%s/api/authz/%s" $scheme $host (include "kube.DNSDomain" $) $path (.Name | default "forward-auth")) -}}
{{- end -}}

{{/*
    Returns the name of the forwardAuth Middleware for forward auth which gets applied to other IngressRoutes.
*/}}
{{- define "authelia.ingress.traefikCRD.middleware.forwardAuth.name" -}}
    {{- if eq .Name "forward-auth" -}}
        {{- if .Values.ingress.traefikCRD.middlewares.auth.nameOverride -}}
            {{- .Values.ingress.traefikCRD.middlewares.auth.nameOverride | trunc 63 -}}
        {{- else -}}
            {{- (printf "forwardauth-%s" (include "authelia.name" .)) | trunc 63 -}}
        {{- end -}}
    {{- else -}}
        {{- $name := .Name | trimPrefix "forward-auth-" -}}
        {{- if .Values.ingress.traefikCRD.middlewares.auth.nameOverride -}}
            {{- (printf "%s-%s" .Values.ingress.traefikCRD.middlewares.auth.nameOverride $name) | trunc 63 -}}
        {{- else -}}
            {{- (printf "forwardauth-%s-%s" (include "authelia.name" .) $name) | trunc 63 -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
    Returns the name of the chain Middleware for forward auth which gets applied to other IngressRoutes.
*/}}
{{- define "authelia.ingress.traefikCRD.middleware.chainAuth.name" -}}
    {{- if eq .Name "forward-auth" -}}
        {{- if .Values.ingress.traefikCRD.middlewares.chains.auth.nameOverride -}}
            {{- .Values.ingress.traefikCRD.middlewares.chains.auth.nameOverride | trunc 63 -}}
        {{- else -}}
            {{- printf "chain-%s-auth" (include "authelia.name" .) -}}
        {{- end -}}
    {{- else -}}
        {{- $name := (.Name | trimPrefix "forward-auth-") -}}
        {{- if .Values.ingress.traefikCRD.middlewares.chains.auth.nameOverride -}}
            {{- (printf "%s-%s" .Values.ingress.traefikCRD.middlewares.chains.auth.nameOverride $name) | trunc 63 -}}
        {{- else -}}
            {{- (printf "chain-%s-auth-%s" (include "authelia.name" .) $name) | trunc 63 -}}
        {{- end -}}
    {{- end -}}
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
  {{- $annotations = set $annotations "traefik.ingress.kubernetes.io/router.middlewares" (printf "%s-%s@kubernetescrd" .Release.Namespace (include "authelia.ingress.traefikCRD.middleware.chainIngress.name" .)) -}}
  {{- end }}
  {{- end -}}
  {{ include "authelia.annotations" (merge (dict "Annotations" $annotations) .) }}
{{- end -}}

{{/*
Returns the name of the chain Middleware for forward auth which gets applied to other IngressRoutes.
*/}}
{{- define "authelia.ingress.traefikCRD.middleware.chainIngress.name" -}}
    {{- printf "chain-%s" (include "authelia.name" .) -}}
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