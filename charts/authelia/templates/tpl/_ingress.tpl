{{/*
Returns true if generation of an ingress is enabled.
*/}}
{{- define "authelia.ingresses.enabled" -}}
    {{- if .Values.ingress -}}
        {{- if .Values.ingress.enabled -}}
            {{- true -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Special Annotations Generator for the Ingress kind.
*/}}
{{- define "authelia.ingress.annotations" -}}
  {{- $annotations := dict -}}
  {{- $annotations = mergeOverwrite $annotations .Values.ingress.annotations -}}
  {{- if and .Values.ingress.traefikCRD .Values.ingress.traefikCRD.disableIngressRoute -}}
  {{- if and (gt (len .Values.ingress.traefikCRD.entryPoints) 0) (not (hasKey $annotations "traefik.ingress.kubernetes.io/router.entryPoints")) -}}
  {{- $annotations = set $annotations "traefik.ingress.kubernetes.io/router.entryPoints" (.Values.ingress.traefikCRD.entryPoints | join ",") -}}
  {{- end -}}
  {{- if not (hasKey $annotations "traefik.ingress.kubernetes.io/router.middlewares") }}
  {{- $annotations = set $annotations "traefik.ingress.kubernetes.io/router.middlewares" (printf "%s-%s@kubernetescrd" .Release.Namespace (include "authelia.traefikCRD.middleware.chain.ingress.name" .)) -}}
  {{- end }}
  {{- end -}}
  {{ include "authelia.annotations" (merge (dict "Annotations" $annotations) .) }}
{{- end -}}

{{/*
Returns true if generation of an Ingress is enabled.
*/}}
{{- define "authelia.ingress.enabled" -}}
    {{- if .Values.ingress.enabled -}}
        {{- if or (not (include "authelia.traefikCRD.enabled" .)) (.Values.ingress.traefikCRD.disableIngressRoute) -}}
            {{- true -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Returns true if generation of an Ingress is enabled.
*/}}
{{- define "authelia.ingress.standard.enabled" -}}
    {{- if and (include "authelia.ingresses.enabled" .) (not (include "authelia.traefikCRD.enabled" .)) -}}
        {{- true -}}
    {{- end -}}
{{- end -}}

{{/*
Returns if we should use existing TraefikCRD TLSOption
*/}}
{{- define "authelia.traefikCRD.tlsOption.enabled" -}}
    {{- if (include "authelia.traefikCRD.enabled" .) -}}
        {{- if .Values.ingress.traefikCRD.tlsOptions -}}
            {{- if .Values.ingress.traefikCRD.tlsOptions.enabled -}}
                {{- if not (include "authelia.traefikCRD.tlsOption.existing" .) -}}
                    {{- true -}}
                {{- end -}}
            {{- end -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Returns true if generation of an IngressRoute is enabled.
*/}}
{{- define "authelia.traefikCRD.ingressRoute.enabled" -}}
    {{- if and (include "authelia.traefikCRD.enabled" .) (not .Values.ingress.traefikCRD.disableIngressRoute) -}}
        {{- true -}}
    {{- end -}}
{{- end -}}

{{/*
Returns if we should use existing TraefikCRD TLSOption
*/}}
{{- define "authelia.traefikCRD.tlsOption.existing" -}}
    {{- if .Values.ingress.traefikCRD.tls -}}
        {{- if .Values.ingress.traefikCRD.tlsOptions.existing -}}
            {{- if .Values.ingress.traefikCRD.tlsOptions.existing.name }}
                {{- true -}}
            {{- end }}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Returns true if generation of the TraefikCRD resources is enabled.
*/}}
{{- define "authelia.traefikCRD.enabled" -}}
    {{- if (include "authelia.ingresses.enabled" .) -}}
        {{- if .Values.ingress.traefikCRD -}}
            {{- if .Values.ingress.traefikCRD.enabled -}}
                {{- true -}}
            {{- end -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Returns the name of the forwardAuth Middleware for forward auth which gets applied to other IngressRoutes.
*/}}
{{- define "authelia.traefikCRD.middleware.forwardAuth.name" -}}
    {{- if .Values.ingress.traefikCRD.middlewares.auth.nameOverride -}}
        {{- .Values.ingress.traefikCRD.middlewares.auth.nameOverride -}}
    {{- else -}}
        {{- printf "forwardauth-%s" (include "authelia.name" .) -}}
    {{- end -}}
{{- end -}}

{{/*
Returns the name of the chain Middleware for forward auth which gets applied to other IngressRoutes.
*/}}
{{- define "authelia.traefikCRD.middleware.chain.auth.name" -}}
    {{- if .Values.ingress.traefikCRD.middlewares.chains.auth.nameOverride -}}
        {{- .Values.ingress.traefikCRD.middlewares.chains.auth.nameOverride -}}
    {{- else -}}
        {{- printf "chain-%s-auth" (include "authelia.name" .) -}}
    {{- end -}}
{{- end -}}

{{/*
Returns the name of the chain Middleware for forward auth which gets applied to other IngressRoutes.
*/}}
{{- define "authelia.traefikCRD.middleware.chain.ingress.name" -}}
    {{- printf "chain-%s" (include "authelia.name" .) -}}
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
    {{- $redirect := (include "authelia.ingress.hostWithPath" .) -}}
    {{- (printf "%s://%s.svc.%s%s/api/verify?rd=https://%s/" $scheme $host $cluster $path $redirect) -}}
{{- end -}}

{{/*
Returns the ingress hostname with the path
*/}}
{{- define "authelia.ingress.hostWithPath" -}}
    {{- printf "%s%s" (include "authelia.ingress.host" .) (include "authelia.path" . | trimSuffix "/") -}}
{{- end -}}

{{/*
Returns the ingress hostname
*/}}
{{- define "authelia.ingress.host" -}}
    {{- if .Values.ingress.subdomain -}}
        {{- printf "%s.%s" (default "auth" .Values.ingress.subdomain) .Values.domain -}}
    {{- else -}}
        {{- .Values.domain -}}
    {{- end -}}
{{- end -}}