# keepalived-nomad-check

This script exits 0 if the queried client is eligible for deployments. Originally written as a check script for keepalived.

Requires [jq](https://github.com/jqlang/jq).

## Keepalived Config

Basic script def:

```
vrrp_script nomad_chk {
  script "/usr/local/bin/keepalived-nomad-check.sh"
  interval 10
  timeout 2
  fall 2
  rise 3
}

vrrp_instance INST {
  ...
  track_script {
    nomad_chk
  }
  ...
}
```

### Nomad ACL

If your cluster has ACLs enabled, you'll need a policy to apply to the token you create for this script.

Below is a minimum viable policy to use:

```hcl
agent {
  policy = "read"
}

node {
  policy = "read"
}
```

### Creating a Token

Once you've created the ACL policy, you can create a token for the script to use with the following command:

```shell
nomad acl token create -name "keepalived nomad eligibility check" -type "client" -policy "keepalived-check" -json
```

This creates a token that does not expire.  You can view the full token create docs here:

[https://developer.hashicorp.com/nomad/docs/commands/acl/token/create](https://developer.hashicorp.com/nomad/docs/commands/acl/token/create)
