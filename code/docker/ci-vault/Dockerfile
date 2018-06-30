# Dockerfile
#
# container image for single-node Vault with file-based backend
#
# author  : stefan schablowski
# contact : stefan.schablowski@desmodyne.com
# created : 2018-01-16

# based on
# https://github.com/hashicorp/docker-vault/blob/master/0.X/Dockerfile @ 00d387d

FROM alpine:3.7
MAINTAINER Stefan Schablowski <stefan.schablowski@desmodyne.com>

# NOTE: ARG vs ENV: https://stackoverflow.com/a/41919137

# Vault release version
ARG vault_version=0.9.3

# Vault user, group and IDs
ARG user=vault
ARG group=vault
ARG uid=1000
ARG gid=1000

# Vault network port
ARG http_port=8200

# Download URL base
ARG url=https://releases.hashicorp.com/vault

# Folder for filebase backend
ARG file_folder=/var/lib/vault

# Folder for log files
ARG logs_folder=/var/log/vault

# NOTE: these must be ENVs, not ARGs, so they are
# available at container _run_ and not only _build_ time

# Folder for vault binary
ENV install_folder=/usr/bin

# Folder for vault configuration file
ENV conf_folder=/etc

# NOTE: each RUN (and COPY and ADD) creates a new Docker image layer:
# https://docs.docker.com/develop/develop-images/ ...
#  ... dockerfile_best-practices/#minimize-the-number-of-layers

# Create system group and user under which the Vault daemon will run;
# explicitly set user and group IDs so volumes on the container host
# can be chown'd to those IDs, even if user and group do not exist there
RUN addgroup -S -g "${gid}"    "${group}" && \
    adduser  -S -u "${uid}" -G "${group}" "${user}"

# Update package index and upgrade all packages
RUN apk update && apk upgrade && \
    # Install group of packages required to build
    apk add --no-cache --virtual .build-dependencies gnupg openssl && \
    # Install packages required to run
    apk add --no-cache ca-certificates dumb-init libcap su-exec && \
    # Fetch HashiCorp GPG key from MIT key server; see also
    # https://www.hashicorp.com/keybase.txt and https://keybase.io/hashicorp
    gpg --keyserver keyserver.ubuntu.com \
        --recv-keys 91A6E7F85D05C65630BEF18951852D87348FFC4C

# Fetch archive, verify integrity, unpack and clean up
RUN mkdir -p /tmp/build && \
    cd /tmp/build && \
    wget "${url}/${vault_version}/vault_${vault_version}_linux_amd64.zip" && \
    wget "${url}/${vault_version}/vault_${vault_version}_SHA256SUMS"      && \
    wget "${url}/${vault_version}/vault_${vault_version}_SHA256SUMS.sig"  && \
    gpg --batch --verify "vault_${vault_version}_SHA256SUMS.sig" \
                         "vault_${vault_version}_SHA256SUMS"  && \
    grep vault_${vault_version}_linux_amd64.zip \
         vault_${vault_version}_SHA256SUMS | sha256sum -c && \
    unzip -d "${install_folder}" vault_${vault_version}_linux_amd64.zip && \
    cd - > /dev/null && \
    rm -rf /tmp/build /root/.gnupg

# Uninstall group of packages required to build
RUN apk del .build-dependencies

# create LHS-conforming folders for filebased backend and log files
RUN mkdir -p "${file_folder}" && chown "${user}:${group}" "${file_folder}" && \
                                 chmod 0700               "${file_folder}" && \
    mkdir -p "${logs_folder}" && chown "${user}:${group}" "${logs_folder}" && \
                                 chmod 0700               "${logs_folder}"

# declare the two folders above as Docker volumes, so their contents
# is preserved on the container host beyond container life cycles
VOLUME "${file_folder}"
VOLUME "${logs_folder}"

# expose network port
EXPOSE "${http_port}"

# copy configuration file
COPY vault.hcl "${conf_folder}/vault.hcl"

# run vault daemon under its own user
USER "${user}"

# NOTE: CMD vs ENTRYPOINT: https://stackoverflow.com/a/34245657

# run dumb-init as top-level process for proper handling of
# processes and signals and gracefully shutdown
# NOTE: sh -c is required to expand install_folder and conf_folder
CMD ["/usr/bin/dumb-init", "sh", "-c", \
     "${install_folder}/vault server -config=${conf_folder}/vault.hcl"]
