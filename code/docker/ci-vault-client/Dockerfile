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
#       /vault/scripts/build-vault /vault/config/vault.local.yaml


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

# NOTE: vault folders are defined by base Dockerfile, do not comply with FHS;
# re-using _server_ folders for _setup client_ files as they are already set up

# vault installation directory
ENV vault_home=/vault

# vault configuration folder
ENV conf_folder=${vault_home}/config

# vault scripts folder
ENV scripts_folder=${vault_home}/scripts

# vault templates folder
ENV tmpl_folder=${vault_home}/tmpl


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

COPY code/vault "${scripts_folder}"
COPY conf/vault "${conf_folder}"
COPY data/tmpl  "${tmpl_folder}"
