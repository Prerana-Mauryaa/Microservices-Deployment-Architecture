{{/*
Define common labels for all resources
*/}}
{{- define "productcatalogservice.labels" -}}
app: {{ .Values.name | default "productcatalogservice" }}
{{- end }}