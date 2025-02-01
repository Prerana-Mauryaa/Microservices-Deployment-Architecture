{{/*
Define common labels for all resources
*/}}
{{- define "emailservice.labels" -}}
app: {{ .Values.name | default "emailservice" }}
{{- end }}
