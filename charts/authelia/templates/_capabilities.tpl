{{/*
Returns an overridable KubeVersion
*/}}
{{- define "capabilities.kubeVersion" -}}
    {{- .Values.kubeVersionOverride | default .Capabilities.KubeVersion.Version -}}
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
Deployment API Version Releases: apps/v1 in 1.9, apps/v1beta2 in 1.8, apps/v1beta1 prior.
*/}}
{{- define "capabilities.apiVersion.deployment" -}}
    {{- if .Capabilities.APIVersions.Has "apps/v1/Deployment" -}}
        {{- print "apps/v1" -}}
    {{- else if .Capabilities.APIVersions.Has "apps/v1beta2/Deployment" -}}
        {{- print "apps/v1beta2" -}}
    {{- else if .Capabilities.APIVersions.Has "apps/v1beta1/Deployment" -}}
        {{- print "apps/v1beta1" -}}
    {{- else if semverCompare ">=1.9-0" (include "capabilities.kubeVersion" .) -}}
        {{- print "apps/v1" -}}
    {{- else if semverCompare ">=1.8-0" (include "capabilities.kubeVersion" .) -}}
        {{- print "apps/v1beta2" -}}
    {{- else -}}
        {{- print "apps/v1beta1" -}}
    {{- end }}
{{- end -}}

{{/*
Returns applicable DaemonSet API version
DaemonSet API Version Releases: apps/v1 in 1.9, apps/v1beta2 in 1.8, apps/v1beta1 prior.
*/}}
{{- define "capabilities.apiVersion.daemonSet" -}}
    {{- if .Capabilities.APIVersions.Has "apps/v1/DaemonSet" -}}
        {{- print "apps/v1" -}}
    {{- else if .Capabilities.APIVersions.Has "apps/v1beta2/DaemonSet" -}}
        {{- print "apps/v1beta2" -}}
    {{- else if .Capabilities.APIVersions.Has "apps/v1beta1/DaemonSet" -}}
        {{- print "apps/v1beta1" -}}
    {{- else if semverCompare ">=1.9-0" (include "capabilities.kubeVersion" .) -}}
        {{- print "apps/v1" -}}
    {{- else if semverCompare ">=1.8-0" (include "capabilities.kubeVersion" .) -}}
        {{- print "apps/v1beta2" -}}
    {{- else -}}
        {{- print "apps/v1beta1" -}}
    {{- end }}
{{- end -}}

{{/*
Returns applicable StatefulSet API version
StatefulSet API Version Releases: apps/v1 in 1.9, apps/v1beta2 in 1.8, apps/v1beta1 prior.
*/}}
{{- define "capabilities.apiVersion.statefulSet" -}}
    {{- if .Capabilities.APIVersions.Has "apps/v1/StatefulSet" -}}
        {{- print "apps/v1" -}}
    {{- else if .Capabilities.APIVersions.Has "apps/v1beta2/StatefulSet" -}}
        {{- print "apps/v1beta2" -}}
    {{- else if .Capabilities.APIVersions.Has "apps/v1beta1/StatefulSet" -}}
        {{- print "apps/v1beta1" -}}
    {{- else if semverCompare ">=1.9-0" (include "capabilities.kubeVersion" .) -}}
        {{- print "apps/v1" -}}
    {{- else if semverCompare ">=1.8-0" (include "capabilities.kubeVersion" .) -}}
        {{- print "apps/v1beta2" -}}
    {{- else -}}
        {{- print "apps/v1beta1" -}}
    {{- end }}
{{- end -}}

{{/*
Returns applicable Ingress API version
Ingress API Version Releases: networking.k8s.io/v1 in 1.19, extensions/v1beta1 prior.
*/}}
{{- define "capabilities.apiVersion.ingress" -}}
    {{- if .Capabilities.APIVersions.Has "networking.k8s.io/v1/Ingress" -}}
        {{- print "networking.k8s.io/v1" -}}
    {{- else if .Capabilities.APIVersions.Has "networking.k8s.io/v1beta1/Ingress" -}}
        {{- print "networking.k8s.io/v1beta1" -}}
    {{- else if semverCompare ">=1.19-0" (include "capabilities.kubeVersion" .) -}}
        {{- print "networking.k8s.io/v1" -}}
    {{- else -}}
        {{- print "networking.k8s.io/v1beta1" -}}
    {{- end }}
{{- end -}}

{{/*
Returns applicable NetworkPolicy API version
NetworkPolicy API Version Releases: networking.k8s.io/v1 in 1.9, extensions/v1beta1 prior.
*/}}
{{- define "capabilities.apiVersion.networkPolicy" -}}
    {{- if .Capabilities.APIVersions.Has "networking.k8s.io/v1/NetworkPolicy" -}}
        {{- print "networking.k8s.io/v1" -}}
    {{- else if .Capabilities.APIVersions.Has "extensions/v1beta1/NetworkPolicy" -}}
        {{- print "extensions/v1beta1" -}}
    {{- else if semverCompare ">=1.9-0" (include "capabilities.kubeVersion" .) -}}
        {{- print "networking.k8s.io/v1" -}}
    {{- else -}}
        {{- print "extensions/v1beta1" -}}
    {{- end }}
{{- end -}}

{{/*
Returns applicable PodDisruptionBudget API version
PodDisruptionBudget API Version Releases: policy/v1 in 1.21, policy/v1beta1 prior.
*/}}
{{- define "capabilities.apiVersion.podDisruptionBudget" -}}
    {{- if .Capabilities.APIVersions.Has "policy/v1/PodDisruptionBudget" -}}
        {{- print "policy/v1" -}}
    {{- else if .Capabilities.APIVersions.Has "policy/v1beta1/PodDisruptionBudget" -}}
        {{- print "policy/v1beta1" -}}
    {{- else if semverCompare ">=1.21-0" (include "capabilities.kubeVersion" .) -}}
        {{- print "policy/v1" -}}
    {{- else -}}
        {{- print "policy/v1beta1" -}}
    {{- end }}
{{- end -}}