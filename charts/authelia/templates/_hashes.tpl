{{/*
    Is truthy if the value provided has a known hash prefix.
*/}}
{{- define "authelia.hashes.prefix.has" -}}
    {{- if or (hasPrefix "$plaintext$" .) (hasPrefix "$base64$" .) }}
        {{- true }}
    {{- else if (include "authelia.hashes.prefix.has.np" .) }}
        {{- true }}
    {{- end }}
{{- end -}}

{{/*
    Is truthy if the value provided has a known hash prefix which is not a plaintext variant.
*/}}
{{- define "authelia.hashes.prefix.has.np" -}}
    {{- if or (hasPrefix "$argon2id$" .) (hasPrefix "$argon2i$" .) (hasPrefix "$argon2d$" .) }}
        {{- true }}
    {{- else if or (hasPrefix "$5$" .) (hasPrefix "$6$" .) }}
        {{- true }}
    {{- else if or (hasPrefix "$pbkdf2$" .) (hasPrefix "$pbkdf2-sha1$" .) (hasPrefix "$pbkdf2-sha224$" .) (hasPrefix "$pbkdf2-sha256$" .) (hasPrefix "$pbkdf2-sha384$" .) (hasPrefix "$pbkdf2-sha512$" .) }}
        {{- true }}
    {{- else if or (hasPrefix "$2$" .) (hasPrefix "$2a$" .) (hasPrefix "$2b$" .) (hasPrefix "$2x$" .) (hasPrefix "$2y$" .) (hasPrefix "$bcrypt-sha256$" .) }}
        {{- true }}
    {{- else if or (hasPrefix "$scrypt$" .) }}
        {{- true }}
    {{- end }}
{{- end -}}