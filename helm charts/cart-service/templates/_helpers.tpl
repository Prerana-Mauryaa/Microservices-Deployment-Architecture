{{/*
Define common labels for resources
*/}}
{{- define "cartservice.labels" -}}
app: {{ .Values.name | default "cartservice" }}
{{- end }}

{{- define "redis.labels" -}}
app: redis-cart
{{- end }}