{{/*
Return the proper file auth backend algorithm
*/}}
{{- define "authelia.config.auth.file.algorithm" -}}
    {{- if or (eq .Values.configMap.authentication_backend.file.password.algorithm "argon2id")  -}}
        {{ "argon2"}}
    {{- else if eq .Values.configMap.authentication_backend.file.password.algorithm "sha512" -}}
        {{ "sha2crypt" }}
    {{- else -}}
        {{ .Values.configMap.authentication_backend.file.password.algorithm }}
    {{- end -}}
{{- end -}}

{{/*
Return the proper file auth backend sha2crypt iterations
*/}}
{{- define "authelia.config.auth.file.iterations.sha2crypt" -}}
    {{- if and (eq .Values.configMap.authentication_backend.file.password.algorithm "sha512") (hasKey .Values.configMap.authentication_backend.file.password "iterations") -}}
        {{ .Values.configMap.authentication_backend.file.password.iterations }}
    {{- else -}}
        {{ .Values.configMap.authentication_backend.file.password.sha2crypt.iterations | default 50000 }}
    {{- end -}}
{{- end -}}

{{/*
Return the proper file auth backend sha2crypt salt_length
*/}}
{{- define "authelia.config.auth.file.salt_length.sha2crypt" -}}
    {{- if and (eq .Values.configMap.authentication_backend.file.password.algorithm "sha512") (hasKey .Values.configMap.authentication_backend.file.password "salt_length") -}}
        {{ .Values.configMap.authentication_backend.file.password.salt_length }}
    {{- else -}}
        {{ .Values.configMap.authentication_backend.file.password.sha2crypt.salt_length | default 16 }}
    {{- end -}}
{{- end -}}

{{/*
Return the proper file auth backend argon2 iterations
*/}}
{{- define "authelia.config.auth.file.iterations.argon2" -}}
    {{- if and (eq .Values.configMap.authentication_backend.file.password.algorithm "argon2id") (hasKey .Values.configMap.authentication_backend.file.password "iterations") -}}
        {{ .Values.configMap.authentication_backend.file.password.iterations }}
    {{- else -}}
        {{ .Values.configMap.authentication_backend.file.password.argon2.iterations | default 3 }}
    {{- end -}}
{{- end -}}

{{/*
Return the proper file auth backend argon2 memory
*/}}
{{- define "authelia.config.auth.file.memory.argon2" -}}
    {{- if and (eq .Values.configMap.authentication_backend.file.password.algorithm "argon2id") .Values.configMap.authentication_backend.file.password.memory -}}
        {{ mul .Values.configMap.authentication_backend.file.password.memory 1024 }}
    {{- else -}}
        {{ .Values.configMap.authentication_backend.file.password.argon2.memory | default 65536 }}
    {{- end -}}
{{- end -}}

{{/*
Return the proper file auth backend argon2 parallelism
*/}}
{{- define "authelia.config.auth.file.parallelism.argon2" -}}
    {{- if and (eq .Values.configMap.authentication_backend.file.password.algorithm "argon2id") .Values.configMap.authentication_backend.file.password.parallelism -}}
        {{ .Values.configMap.authentication_backend.file.password.parallelism }}
    {{- else -}}
        {{ .Values.configMap.authentication_backend.file.password.argon2.parallelism | default 4 }}
    {{- end -}}
{{- end -}}

{{/*
Return the proper file auth backend argon2 key_length
*/}}
{{- define "authelia.config.auth.file.key_length.argon2" -}}
    {{- if and (eq .Values.configMap.authentication_backend.file.password.algorithm "argon2id") .Values.configMap.authentication_backend.file.password.key_length -}}
        {{ .Values.configMap.authentication_backend.file.password.key_length }}
    {{- else -}}
        {{ .Values.configMap.authentication_backend.file.password.argon2.key_length | default 32 }}
    {{- end -}}
{{- end -}}

{{/*
Return the proper file auth backend argon2 salt_length
*/}}
{{- define "authelia.config.auth.file.salt_length.argon2" -}}
    {{- if and (eq .Values.configMap.authentication_backend.file.password.algorithm "argon2id") (hasKey .Values.configMap.authentication_backend.file.password "salt_length") -}}
        {{ .Values.configMap.authentication_backend.file.password.salt_length }}
    {{- else -}}
        {{ .Values.configMap.authentication_backend.file.password.argon2.salt_length | default 16 }}
    {{- end -}}
{{- end -}}