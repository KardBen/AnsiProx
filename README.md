# AnsiProx
An Ansible project that clones and provisions Proxmox VMs from a template using cloud-init.

**What it does**
Clones a template VM, applies CPU/memory and cloud-init settings, resizes the disk, and starts the VM. The core logic lives in `roles/clone_vm/tasks/main.yaml`.

**Requirements**
- Ansible
- Proxmox API access (user + API token)
- Ansible collection `community.proxmox`
- Python module `proxmoxer`
- Python module `requests`

**Setup**
Install any galaxy roles listed in `requirements.yml`:
```bash
make setup
```

Install the Proxmox collection (if you don't already have it):
```bash
ansible-galaxy collection install community.proxmox
```

**Configuration**
Inventory is in `hosts.yaml` (Proxmox host group). Example:
```yaml
proxmox:
  hosts:
    192.168.1.1:
```

Global variables are in `group_vars/all/main.yaml`. Sensitive values are expected to come from vault variables:
```yaml
proxmox_api_host: "{{ vault_proxmox_api_host }}"
proxmox_api_user: "{{ vault_proxmox_api_user }}"
proxmox_api_token_id: "{{ vault_proxmox_api_token_id }}"
proxmox_api_token_secret: "{{ vault_proxmox_api_token_secret }}"
proxmox_node: "{{ vault_proxmox_node }}"
cloud_init_sshkeys: "{{ vault_cloud_init_sshkeys }}"
```

The example playbook `pb_example.yaml` shows the required and optional runtime vars:
- `template_vm_name`, `template_vm_id`
- `clone_vm_name`, `clone_vm_id`
- `clone_vm_cpu_cores`, `clone_vm_memory_size`
- `cloud_init_user`, `cloud_init_password`
- `cloud_init_ipconfig`, `cloud_init_nameservers`
- Optional: `clone_vm_disk_identifier` (default `scsi0`)
- Optional: `clone_vm_disk_resize_value` (default `+100G`)

**Usage**
Run the example playbook:
```bash
ansible-playbook pb_example.yaml
```

If you want `make run` to work, adapt the needed playbook name in the Makefile (for example, by copying `pb_example.yaml`) since the Makefile expects a correct filename.
