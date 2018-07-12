URL   : https://github.com/hashicorp/vault/issues/4912
title : JSON / "hidden" switch in UI fails with non-string secrets values

**Bug Description**

When uploading secrets JSON data with _non-string_ secrets values (e.g. integer, float, `null`), the _JSON_ switch at the top right of the `<vault address>/ui/vault/secrets/secret/show/<location>` UI web page does not correctly switch between "raw" JSON data and key/value display with (secret) values being hidden; the switch seems to do nothing.

This issue only occurs when uploading data using `curl`, the `vault` command client seems to convert integers and floats to strings.

**To Reproduce**

1. Run a vault server with the UI supported and enabled (e.g. macOS binary does not seem to contain it).
2. Run `curl` to upload some test data (no shell prompt included below for easier copy & paste):

```
export VAULT_ADDR=<insert yours>
export VAULT_TOKEN=<insert yours>
curl --data '{ "secret_key": "test" }' --header "X-Vault-Token: ${VAULT_TOKEN}" --request POST "${VAULT_ADDR}/v1/secret/test_string"
curl --data '{ "secret_key": 123456 }' --header "X-Vault-Token: ${VAULT_TOKEN}" --request POST "${VAULT_ADDR}/v1/secret/test_integer"
curl --data '{ "secret_key": 1.3456 }' --header "X-Vault-Token: ${VAULT_TOKEN}" --request POST "${VAULT_ADDR}/v1/secret/test_float"
curl --data '{ "secret_key": null   }' --header "X-Vault-Token: ${VAULT_TOKEN}" --request POST "${VAULT_ADDR}/v1/secret/test_null"
```

3. See error

Open the various secrets display pages in a web browser and try the _JSON_ switch at the top right:

+ `${VAULT_ADDR}/ui/vault/secrets/secret/show/test_string`: works as expected
+ `${VAULT_ADDR}/ui/vault/secrets/secret/show/test_integer`: switch does notthing
+ `${VAULT_ADDR}/ui/vault/secrets/secret/show/test_float`: switch does notthing
+ `${VAULT_ADDR}/ui/vault/secrets/secret/show/test_null`: switch does notthing

**Expected behavior**

_JSON_ switch should work for all test cases as it does for secrets strings.

**Additional cosmetic bug**

On `${VAULT_ADDR}/ui/vault/secrets/secret/list` secrets list page, `test_null` is displayed as `test_`.

**Environment:**
* Vault Server Version: 0.10.3
* Vault CLI Version: Vault v0.10.3 ('533003e27840d9646cb4e7d23b3a113895da1dd0')
* Server Operating System/Architecture: macOS with vault server mostly running in Docker container

Vault server configuration file(s):

```hcl
storage "file" {
  path = "/vault/file"
}

listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = 1
}

ui = true

disable_mlock = true
```

**Additional context**

Question is if it should be possible at all to upload non-string secret values; at the moment, they are silently accepted. Maybe the vault should reject them and  have the HTTP request fail - or at least display a warning.
