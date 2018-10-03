FROM php:{{.PHP_VERSION}}-cli-stretch


# workdir
RUN mkdir -p /app
WORKDIR /app


{{template "Dockerfile.prerequisites.inc" .}}

{{template "Dockerfile.ast.inc" .}}

{{template "Dockerfile.composer.inc" .}}
