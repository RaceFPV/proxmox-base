# Terraform for physical servers and proxmox vms

Provider info: https://registry.terraform.io/providers/Telmate/proxmox/latest/docs

# Initial setup
### Set vars
Be sure to set your proxmox api token and powerdns api token as envvars before starting:

```export PROX_ID="terraform-prov@pve!mytoken"
export PROX_SECRET="afcd8f45-acc1-4d0f-bb12-a70b07711111"
export PDNS_SECRET="my-powerdns-api-key"
export TF_VAR_PROX_URL='https://10.0.0.5:8006/api2/json''```

Also be sure to set the powerdns server url in the provider.tf file to the correct powerdns server. Or remove the powerdns provider block if you don't need it.

A recommended way to easily change between environments is setting an alias in your ~/.bashrc or ~/.zshrc file instead of hardcoded/repeating exports.


# How to use
### Change directory
Enter the directory where you need to modify/add vms, for example `cluster1/deployment1`

### Modify variables
Change `values.yaml` for the respective environment/vm type by adding or modifying existing vm's as needed.

### Apply config
```terraform apply```


# Extras
### Importing preexisting resources
To import existing resources:

```terraform import --var-file values.yaml proxmox_vm_qemu.proxmox_vms proxmox-server-1/qemu/101```

After importing you'll need to edit the terraform state and add in the index_key for the imported resource, matching whats in the .tfvars

### Notes