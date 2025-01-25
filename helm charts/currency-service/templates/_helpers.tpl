{{/*
Define common labels for all resources
*/}}
{{- define "currencyservice.labels" -}}
app: {{ .Values.name | default "currencyservice" }}
{{- end }}