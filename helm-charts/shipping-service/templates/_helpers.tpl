{{/*
Define common labels for all resources
*/}}
{{- define "shippingservice.labels" -}}
app: {{ .Values.name | default "shippingservice" }}
{{- end }}