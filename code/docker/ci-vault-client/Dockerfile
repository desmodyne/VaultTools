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

FROM vault:latest
MAINTAINER Stefan Schablowski <stefan.schablowski@desmodyne.com>

# install bash, required by client scripts
# https://stackoverflow.com/a/40944512
RUN apk update && apk add --no-cache bash

# ARG vs ENV: https://stackoverflow.com/a/41919137

# vault installation directory
ENV vault_folder=/opt/vault

RUN mkdir -p "${vault_folder}"

# NOTE: Docker does not support relative paths, using e.g. ../bin fails with
#   COPY failed: Forbidden path outside the build context: ../bin ()
# therefore, this image must be built using .../cicd/bin/build-basic-images
COPY bin  "${vault_folder}/"
COPY conf "${vault_folder}/"
COPY tmpl "${vault_folder}/"
