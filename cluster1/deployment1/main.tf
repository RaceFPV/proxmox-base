locals {
  settings = yamldecode(file("./values.yaml"))
}

resource "proxmox_vm_qemu" "proxmox_vms" {
  for_each = local.settings.proxmox_vms

  name        = each.value.hostname
  desc        = "created by terraform"
  target_node = each.value.target_node
  os_type = "ubuntu" // assumes ubuntu for the vm template
  qemu_os = "l26"
  ciuser = "ubuntu"

  clone = each.value.vm_template
  full_clone = true

  cpu = each.value.cpu_type
  cores   = each.value.cpu_cores
  sockets = each.value.cpu_sockets
  numa = false // if you want to use numa and memory hotplug, set to true
  memory  = each.value.memory
  hotplug = "network,disk,usb,cpu"
  onboot = true
  vm_state = "running"
  agent = 1
  ipconfig0 = "ip=dhcp"

  network {
    model = "virtio"
    bridge = "vmbr1" // name of your openvswitch bridge, otherwise remove this line + tag line
    tag = "11"
  }

  disks {
    scsi {
      scsi0 {
        disk {
          discard = false
          emulatessd = false
          iothread = false
          readonly = false
          replicate = false
          asyncio = "io_uring"
          backup = false
          cache = "none"
          size = each.value.disk_size
          storage = "ceph" // replace with whatever your storage backend is named
        }
      }
    }
  }

  ssh_user = each.value.ssh_user
  ssh_private_key = "${file(local.settings.ssh_private_key)}"
  connection {
    type = "ssh"
    user = self.ssh_user
    private_key = self.ssh_private_key
    host = self.ssh_host
  }

  provisioner "remote-exec" {
    inline = [
      "sudo systemd-machine-id-setup",
      "sudo hostnamectl set-hostname ${self.name}",
      "sudo hostnamectl set-hostname ${self.name} --pretty",
      "sudo hostname ${self.name}",
      "sudo shutdown -r 1", //we do this to make sure the hostname changes stick
    ]
  }

  lifecycle {
    ignore_changes = [
        network,disks,bootdisk,target_node,clone_wait,additional_wait,scsihw
    ]
  }
}

# Add A record to the zone via powerdns
resource "powerdns_record" "proxmox_dns" {
  for_each = proxmox_vm_qemu.rancher_vms

  zone    = "k3s.live."
  name    = "${each.value.name}.k3s.live."
  type    = "A"
  ttl     = 300
  records = ["${try(length(each.value.ssh_host), 0) > 0 ? each.value.ssh_host}"]

  lifecycle {
    ignore_changes = [
        records
    ]
  }
}