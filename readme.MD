# Terraform for physical servers and proxmox vms

Provider info: https://registry.terraform.io/providers/Telmate/proxmox/latest/docs

# Initial setup
### Set values.yaml
First look over the values.yaml, changing anything related to cpu/mem/server name you'd like

### Set vars
Be sure to set your proxmox api token as envvars before starting:

```export PROX_ID="terraform-prov@pve!mytoken"
export PROX_SECRET="afcd8f45-acc1-4d0f-bb12-a70b07711111"
export TF_VAR_PROX_URL='https://10.0.0.5:8006/api2/json''```

A recommended way to easily change between environments is setting an alias in your ~/.bashrc or ~/.zshrc file instead of hardcoded/repeating exports.

### Create a proxmox vm template
This code assumes you have a proxmox vm template already created and that it's named `docker-template`. It also assumes the template is ubuntu and has the following:
- a user named 'ubuntu'
- qemu-guest-agent installed
- a bridge named `vmbr1` that is connected to the proxmox server's physical network interface (this can be changed in main.tf)
- a vlan tag of `11` on the bridge (this can be changed in main.tf)
- a copy of the ssh private key to access the vm located in '~/.ssh/proxmox_nodes'
- a storage backend named 'ceph' (change in main.tf if you use a different storage backend)


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