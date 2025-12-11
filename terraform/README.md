

VM ID 3** - dev environment  | module.dev | these resources are temporary intermediaries to provision more future resources
VM ID 2** - prod environment | module.ephemeral 
VM ID 1** - persistent and manually managed resources | module.persistent

The flow to setup a base image is as follows:

import the resources in modules.persistent, these are templates that must never be deleted and are 
marked as protected in proxmox. we only care about "base_template_raw", a frozen vm that contains
a freshly installed instance of debian with cloud-init configured. plans to automate this later with 
a debian preseed script. 

provision modules.dev, this creates a thawed vm of the raw base image that we're going to modify into 
our ideal developmental image. 

run the ansible playbooks in "base_image" against the vm in modules.dev. this transforms the raw 
image into a fully configured machine that has everything you'd want in a clone. 

provision modules.base_image. this takes the base_image vm and freezes it into a template, making it ready 
to be cloned. 

provision modules.ephemeral, which clones the base_image into all the machines for a k3 cluster you need. 