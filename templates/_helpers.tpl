{{/*
Expand the name of the chart.
*/}}
{{- define "cloudifytests.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "cloudifytests.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "cloudifytests.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper cloudifytests image name
*/}}
{{- define "cloudifytests.image" -}}
{{- $registryName := .Values.cloudifytests.image.registry -}}
{{- $repositoryName := .Values.cloudifytests.image.repository -}}
{{- $tag := .Values.cloudifytests.image.tag | toString -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global }}
    {{- if .Values.global.imageRegistry }}
        {{- printf "%s/%s:%s" .Values.global.imageRegistry $repositoryName $tag -}}
    {{- else -}}
        {{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
    {{- end -}}
{{- else -}}
    {{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper nginx image name
*/}}
{{- define "nginx.image" -}}
{{- $registryName := .Values.nginx.image.registry -}}
{{- $repositoryName := .Values.nginx.image.repository -}}
{{- $tag := .Values.nginx.image.tag | toString -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.nginx.image.registry }}
    {{- printf "%s/%s:%s" .Values.nginx.image.registry $repositoryName $tag -}}
{{- else -}}
    {{- printf "%s:%s" $repositoryName $tag -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper sessionUi image name
*/}}
{{- define "sessionUi.image" -}}
{{- $registryName := .Values.sessionUi.image.registry -}}
{{- $repositoryName := .Values.sessionUi.image.repository -}}
{{- $tag := .Values.sessionUi.image.tag | toString -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.sessionUi.image.registry }}
    {{- printf "%s/%s:%s" .Values.sessionUi.image.registry $repositoryName $tag -}}
{{- else -}}
    {{- printf "%s:%s" $repositoryName $tag -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper nginx.prometheusExporter image name
*/}}
{{- define "nginx.prometheusExporter.image" -}}
{{- $registryName := .Values.nginx.prometheusExporter.image.registry -}}
{{- $repositoryName := .Values.nginx.prometheusExporter.image.repository -}}
{{- $tag := .Values.nginx.prometheusExporter.image.tag | toString -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.nginx.prometheusExporter.image.registry }}
    {{- printf "%s/%s:%s" .Values.nginx.prometheusExporter.image.registry $repositoryName $tag -}}
{{- else -}}
    {{- printf "%s:%s" $repositoryName $tag -}}
{{- end -}}
{{- end -}}
