# vault.hcl
#
# HashiCorp Vault configuration file
#
# author  : stefan schablowski
# contact : stefan.schablowski@desmodyne.com
# created : 2018-02-17


# https://www.vaultproject.io/docs/configuration/index.html


# NOTE: in theory, this should be e.g. /var/lib/vault/;
# in practice, the base Dockerfile doesn't care about FHS
storage "file" {
  path = "/vault/file"
}

# TODO: enable TLS to secure network traffic
listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = 1
}
