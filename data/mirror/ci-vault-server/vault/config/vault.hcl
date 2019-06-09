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

# https://www.vaultproject.io/docs/configuration/#api_addr
# NOTE: this is mostly added to prevent warning in server logs:
#   no `api_addr` value specified in config or in VAULT_API_ADDR;
#   falling back to detection if possible, but this value should be manually set
api_addr = "http://0.0.0.0:8200"

# activate built-in management UI
# https://www.vaultproject.io/docs/configuration/ui/index.html
ui = true

# https://www.vaultproject.io/docs/configuration/index.html#disable_mlock
# required as vault daemon does not run as root and does not have sufficient
# privileges to perform an mlock system call; most cloud platforms (such as
# AWS or Sloppy) don't have any swap space, so it is safe to set this
disable_mlock = true
