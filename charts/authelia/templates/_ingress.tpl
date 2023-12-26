{{/*
Returns the file configuration list as a csv.
*/}}
{{- define "authelia.ingress.host" -}}
    {{- if .SubDomain }}
    {{- printf "%s.%s" .SubDomain .Domain }}
    {{- else }}
    {{- .Domain }}
    {{- end }}
{{- end }}

{{/*
Returns the forward auth url
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
    {{- (printf "%s://%s.svc.%s%s/api/authz/%s" $scheme $host $cluster $path (.Values.ingress.traefikCRD.middlewares.auth.endpointOverride | default "forward-auth")) -}}
{{- end -}}

{{/*
    Returns the name of the forwardAuth Middleware for forward auth which gets applied to other IngressRoutes.
    TODO: Rework.
*/}}
{{- define "authelia.ingress.traefikCRD.middleware.name.forwardAuth" -}}
    {{- if .Values.ingress.traefikCRD.middlewares.auth.nameOverride -}}
        {{- .Values.ingress.traefikCRD.middlewares.auth.nameOverride -}}
    {{- else -}}
        {{- printf "forwardauth-%s" (include "authelia.name" .) -}}
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

{{/*
Returns the name of the chain Middleware for forward auth which gets applied to other IngressRoutes.
*/}}
{{- define "authelia.ingress.traefikCRD.middleware.name.chainIngress" -}}
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