{{/*
Define common labels for all resources
*/}}
{{- define "recommendationservice.labels" -}}
app: {{ .Values.name | default "recommendationservice" }}
{{- end }}
