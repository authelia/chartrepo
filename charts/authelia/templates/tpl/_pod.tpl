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
        {{- .Values.pod.replicas | default 1 -}}
      {{- end -}}
{{- end -}}

{{/*
Returns the pod management policy
*/}}
{{- define "authelia.podManagementPolicy" -}}
      {{- if (include "authelia.stateful" .) }}
        {{- "Parallel" -}}
      {{- else -}}
        {{- .Values.pod.managementPolicy | default "Parallel" -}}
      {{- end -}}
{{- end -}}