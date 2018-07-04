# Dockerfile
#
# container image for HashiCorp Vault client setup
#
# author  : stefan schablowski
# contact : stefan.schablowski@desmodyne.com
# created : 2018-07-02


# NOTE: run this with e.g.
#   docker run --cap-add IPC_LOCK --name ct-vault -p 8200:8200 ci-vault \
#     vault server -config /vault/config

# TODO: un-expose port 8200 inherited from base container

FROM vault:latest
MAINTAINER Stefan Schablowski <stefan.schablowski@desmodyne.com>

# install tools required by client scripts
# https://stackoverflow.com/a/40944512
# TODO: rm /var/cache/apk/* ?
# TODO: update yq 1.15 to latest 2.0.1
RUN apk update && apk add --no-cache bash curl jq python py-pip && \
    wget -O /usr/local/bin/yq \
        https://github.com/mikefarah/yq/releases/download/1.15.0/yq_linux_amd64 && \
    chmod a+x /usr/local/bin/yq && \
    pip install --upgrade pip && pip install j2cli

# ARG vs ENV: https://stackoverflow.com/a/41919137

# vault installation directory
ENV vault_folder=/opt/vault

RUN mkdir -p "${vault_folder}"

# NOTE: Docker does not support relative paths, using e.g. ../bin fails with
#   COPY failed: Forbidden path outside the build context: ../bin ()
# therefore, this image must be built using .../cicd/bin/build-basic-images
COPY bin  "${vault_folder}/bin"
COPY conf "${vault_folder}/conf"
COPY tmpl "${vault_folder}/tmpl"
