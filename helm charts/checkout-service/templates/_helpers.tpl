{{/*
Define common labels for all resources
*/}}
{{- define "checkoutservice.labels" -}}
app: {{ .Values.name | default "checkoutservice" }}
{{- end }}
