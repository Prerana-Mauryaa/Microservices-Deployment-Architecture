{{/*
Define common labels for all resources
*/}}
{{- define "frontend.labels" -}}
app: {{ .Values.name | default "frontend" }}
{{- end }}