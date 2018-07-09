# Dockerfile
#
# container image for single-node Vault with file-based backend
#
# author  : stefan schablowski
# contact : stefan.schablowski@desmodyne.com
# created : 2018-01-16


# https://hub.docker.com/_/vault/
# https://github.com/hashicorp/docker-vault

# NOTE: run this with e.g.
#   docker run --cap-add IPC_LOCK --name ct-vault -p 8200:8200 ci-vault \
#     vault server -config /vault/config

FROM vault:latest
MAINTAINER Stefan Schablowski <stefan.schablowski@desmodyne.com>

# ARG vs ENV: https://stackoverflow.com/a/41919137

# vault configuration folder
# NOTE: in theory, this should be e.g. /etc/vault/;
# in practice, the base Dockerfile doesn't care about FHS
ENV conf_folder=/vault/config

# copy configuration file
COPY data/mirror/ci-vault-server/vault/config/vault.hcl "${conf_folder}/vault.hcl"
