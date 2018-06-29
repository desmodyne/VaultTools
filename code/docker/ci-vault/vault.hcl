# vault.hcl
#
# HashiCorp Vault configuration file
#
# author  : stefan schablowski
# contact : stefan.schablowski@desmodyne.com
# created : 2018-02-17


# https://www.vaultproject.io/docs/configuration/index.html


storage "file" {
  path = "/var/lib/vault"
}

listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = 1
}

# required as vault daemon does not run as root;
# AWS container host has no swap space anyway...
disable_mlock = true
