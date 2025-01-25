{{/*
Define common labels for all resources
*/}}
{{- define "paymentservice.labels" -}}
app: {{ .Values.name | default "paymentservice" }}
{{- end }}