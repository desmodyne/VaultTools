# Dockerfile
#
# container image for single-node HashiCorp Vault server with file-based backend
#
# author  : stefan schablowski
# contact : stefan.schablowski@desmodyne.com
# created : 2018-01-16


# NOTE: see ../ci-vault-client/Dockerfile for some possibly informative comments


# https://github.com/hashicorp/docker-vault
# https://hub.docker.com/_/vault/

# NOTE: once built by CI/CD script, run the container using e.g.
#   $ docker run --cap-add IPC_LOCK --name ct-vault-server --publish 8200:8200 \
#       desmodyne/ci-vault-server vault server -config /vault/config


# ------------------------------------------------------------------------------
# NOTE: for multi-stage containers, global settings may (and should as per
# convention) be the first section in any Dockerfile; single-stage containers
# must start with a FROM statement; otherwise building fails with
#   Error response from daemon: No build stage in current context

FROM vault:latest


# ------------------------------------------------------------------------------
# configure global stage / container settings

LABEL maintainer="DesmoDyne Docker Maintainers <docker@desmodyne.com>"

# NOTE: vault folders are defined by base Dockerfile, do not comply with FHS

# vault installation directory
ENV vault_home=/vault

# vault configuration folder
ENV conf_folder=${vault_home}/config


# ------------------------------------------------------------------------------
# execution stage / container

# copy configuration file
COPY data/mirror/ci-vault-server/vault/config/vault.hcl "${conf_folder}"
