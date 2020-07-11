FROM php:{{.PHP_VERSION}}-cli-buster


# workdir
RUN mkdir -p /app
WORKDIR /app


{{template "Dockerfile.prerequisites.inc" .}}

{{template "Dockerfile.ast.inc" .}}
