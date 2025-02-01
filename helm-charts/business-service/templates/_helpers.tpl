{{/*
Define common labels for all resources
*/}}
{{- define "business-service.labels" -}}
app: {{ .Values.name | default "business-service" }}
{{- end }}