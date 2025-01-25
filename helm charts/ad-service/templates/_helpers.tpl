{{/*
Define common labels for all resources
*/}}
{{- define "adservice.labels" -}}
app: {{ .Values.name | default "adservice" }}
{{- end }}