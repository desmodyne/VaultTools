# Dockerfile
#
# container image for HashiCorp Vault setup client
#
# author  : stefan schablowski
# contact : stefan.schablowski@desmodyne.com
# created : 2018-07-02


# https://github.com/hashicorp/docker-vault
# https://hub.docker.com/_/vault/


# NOTE: in order to build this container standalone, provide the context path:
#   # change to folder underneath project root (indicated by '...')
#   $ cd .../code/docker/ci-vault-client
#   $ docker build -f Dockerfile ../../..
#     ...
#   $ cd - > /dev/null
#
# however, the recommended approach is to use CI/CD build scripts
# (which builds all artifacts (i.e. containers) in this project
#  and also takes care of properly tagging the image):
#   # change to project root (indicated by '...')
#   $ cd ...
#   $ ./cicd/bin/build ./cicd/conf/cicd.yaml
#     ...
#   $ cd - > /dev/null
# which is considered the canonical way also followed by any CI tools

# NOTE: once built by CI/CD script, run the container using e.g.
#   $ docker run --name ct-vault-client desmodyne/ci-vault-client
#       /opt/vault/bin/build-vault /opt/vault/conf/vault.localhost.yaml


# ------------------------------------------------------------------------------
# NOTE: for multi-stage containers, global settings may (and should as per
# convention) be the first section in any Dockerfile; single-stage containers
# must start with a FROM statement; otherwise building fails with
#   Error response from daemon: No build stage in current context

FROM vault:latest


# ------------------------------------------------------------------------------
# configure global stage / container settings

LABEL maintainer="DesmoDyne Docker Maintainers <docker@desmodyne.com>"

# ARG vs ENV: https://stackoverflow.com/a/41919137

# vault installation directory
ENV vault_folder=/opt/vault


# ------------------------------------------------------------------------------
# execution stage / container

# install tools required by client scripts
# https://stackoverflow.com/a/40944512
# TODO: rm /var/cache/apk/* ?
# TODO: update yq 1.15 to latest 2.0.1
RUN apk update && apk add --no-cache bash curl jq python py-pip && \
    wget -O /usr/local/bin/yq \
        https://github.com/mikefarah/yq/releases/download/1.15.0/yq_linux_amd64 && \
    chmod a+x /usr/local/bin/yq && \
    pip install --upgrade pip && pip install j2cli

RUN mkdir -p "${vault_folder}"

COPY code/vault "${vault_folder}/bin"
COPY conf/vault "${vault_folder}/conf"
COPY data/tmpl  "${vault_folder}/tmpl"
