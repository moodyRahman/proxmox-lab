# Proxmox Infra Lab

So I wanted to learn Kubernetes. 

You think this would be pretty simple, boot up minikube or kind and get cracking. 
I did that and it felt pretty bland for lack of better words, overly unrealistic 
as to simulating real life screwy conditions that lets Kubernetes really shine. 
No real way to simulate the various ways a node can fail or watch how the system 
handles it. 

I discussed with a trusted engineer and they reccommended I run Proxmox, a type 1 
hypervisor that lets me run virtual machines that I can treat as if they're their 
own node. My server was already busy running my stack of self-hosted applications, 
and I didn't want to interrupt that, so against Proxmox's advice I performed an 
in-place upgrade to the pve kernel. 

I went ahead, provisioned three VM's, installed Debian onto them, and started 
following Kelsey Hightower's wonderful, Kubernetes the Hard Way. Each of the VM's 
was a from scratch Debian box with nothing installed, so I had to manually go through 
them and configure _everything_, sshd, keys, all sorts of dependencies and dev tools, 
and their /etc/hosts file so I won't tear my hair out later dealing with IP address typos. 

Turns out... I suck at running commands, espcially when there's as many moving 
parts as Hightower's guide. I got stuck at setting up the Certificate Authority, 
tried to rectify it, but it became a situation where it was hard to tell whether 
each command I ran was a step towards or away the fix. I figure I'd delete and 
reprovision the VM's given and start from scratch and be really, _really_ careful. 

So I do that, and go through every step again, sshd, keys, all sorts of dependencies 
and dev tools, and their /etc/hosts file so I won't tear my hair out later dealing 
with IP address typos. 

And again something got bungled up.

It occurred to me, _"I'm an infrastructure engineer dude, what am I doing manually configuring servers like a chump?"_

I dove into the Proxmox docs, hoping to stumble into some entry that could bring 
inspiration to solve my problems. And that inspiration came in the form of the "template", 
a VM that's frozen and cloneable. I make a VM that has the idempotent traits that I need, 
configs and keys and dev tools. Something like the /etc/hosts can't be a part of the base 
template as IP's are assigned via DHCP _after_ the VM is provisioned. 

A subtle issue that I ran into was that after the template was cloned, the VM's hostname 
was still that of the template and not what the VM was named in Proxmox, so every new VM 
had to have its hostname manually edited as well as its loopback entry in /etc/hosts. It 
also still left the issue of the /etc/hosts having no idea about any of the adjacent VM's 
that are a part of the Kubernetes cluster, leaving that to be still manually configured. 

Eventually I came to the conclusion that it's time to whip out Ansible so I can automate 
the remaining configuration for each machine, and Terraform so I can freely create and 
destroy VM's as well as "terraform output" to grab the IP addresses and hostnames for the 
VM's so Ansible can pull the right information to run it's playbooks. 

Now I'm looking at Terraform providers for Proxmox, of which there's no single best 
option. The most fleshed out and actively updated option is bpg/proxmox. It's only caveat 
was that it targets Proxmox 9. I'm running Proxmox 8. 

I begin to upgrade my Debian-turned-Proxmox 8 to Proxmox 9, which went horribly wrong. 
Something in /boot/efi was screwed up and couldn't recognize the drive as bootable 
anymore, even after booting up a recovery drive and mounting and chroot-ing into the boot 
disk and poking around. 

This was exceptionally scary because by now, I had migrated my stack of selfhosted 
applications into their own VM. The prospect of a system wipe and a fresh install seemed 
to suggest that I would fully lose out on years worth of data, which was unacceptable. 

After some thinking, I had hit a nugget of inspiration. Let me pose a question to you, the 
reader: "Where on a computer does it's soul lie?"

It's not the CPU or the RAM, you can swap these freely and it won't affect the behavior of 
a computer as much as it will affect the specifics of its performance. The part of a 
computer that contains everything that defines it, the kernel, the programs, 
configurations and autostarts and data all live in it's hard drive. If I could somehow 
rescue the virtual hard drive, then couldn't I theoretically recreate the VM in a whole 
new Proxmox host? Of course in hindsight, this is literally how backups and restores of 
any computer system works, but it was my first time working in such a virtualized 
environment. 

I had to verify this insight first. I found a wonderful project called "pve-live" (kudos 
to LongQT-sea on GitHub) that's a live image of Proxmox. I took a trip to Microcenter to 
buy some flashdrives, copied the .qcow2 file that corresponded to the virtual hard drive I 
wanted to rescue, and mounted that flashdrive onto the Proxmox live image. It worked 
flawlessly, and the VM booted up as if nothing had happened. 

This meant that the only thing that I had to preserve was this singular .qcow2 file, and 
the rest was free to destroy as I do a fresh install of Proxmox 9. 

The rest of the installation went without a hitch and I enjoyed my new Proxmox 9 
installation. 

While figuring out the whole fiasco, I read up on another feature called Cloud-Init, that 
had wholly solved the issue of getting a VM's hostname to match it's name in the 
hypervisor. 

It left the final issue of conveniently networking the VM's together. I was considering 
solutions like keeping the VM's in their own VLAN, or maybe an intermediary DHCP server 
with reservations and configure the nodes to have always have the same MAC address as 
their previous incarnations. 

Ultimately, I chose to try and get Tailscale up and configured on each node as they are 
provisioned, which turned out to be a smashing success. I learned some about the internals 
of Tailscale and modified the base template to be devoid of any state, but preloaded with 
a script that handles the initial Tailscale configuration and authentication and a systemd 
service that makes sure that it's run on boot if it doesn't detect an active Tailscale 
connection. 

What was a painfully tedious process of provisioning and configuring VM's has become... 
zero configuration. 

After all that, I can finally get back into the Terraform. My goals have shifted some, and 
now it's to write an Ansible playbook that can perform Kubernetes the Hard Way on my 
behalf. Terraform is still incredible useful here as if I send a node into some 
unrecoverable state, deleting it and reprovisioning it is trivial and I can tweak my 
Ansible script as needed. 

After Terraform import-ing the base template into the tfstate, my big worry was that I did 
not want to risk any chance whatsoever of my base image being deleted by Terraform. 
Wonderfully enough is that Terraform has this built in with the "lifecycle", letting me 
mark the base template as something to never be deleted. I also have several backups of 
the templates .qcow2 file and plans to create an Ansible script to reproduce the base 
template. 

The next issue hit when I realized that resizing the virtual drive in Proxmox does not 
actually expand the partitions inside the VM to use up the unallocated space. This was 
a problem because I wanted my base image to be as minimally configurable as possible, 
ie expanding the virtual disk should be immediately reflected in the operating system. 

This had turned out to be a structural issue with the way I had gone through the Debian 
installer ISO, and the default ordering of partititions made it difficult to write a 
failproof partition resize script. This was the point I had gotten sick of manually working 
on the base template and moved to automating that too. 

I did some reading on Debian preseed scripts to automate the initial installation of Debian
onto a blank serber and played around, but I re-prioritized it as a feature to pursue 
at a later time. I created the "base-image-raw" template, which has absolutely nothing 
on it and is the freshest possible Debian server after configuring LVM in the installer. 

Next, I wrote ansible playbooks that would perform the initial configuring of the machine for 
future ansible playbooks, enable passwordless root, install dependencies, and copy keys. 
Further research would reveal that most cloud images don't even bother with partitions, 
they have a single partition with a filesystem that's mounted on root, regarding whether 
the LVM configurations are useful as an ongoing conversation with myself. The wonderful 
part is that I can easily make that decision and try things out, as all of the configuration 
has been refactored into my playbooks. I decided to forgo the layer of LVM and opted back into
a single partition with a swapfile. I also experimented with using UEFI for the base template 
rather than MBR to simplify the process of expanding the disk into unallocated space to some 
unsuccess, but it also further proved the value of having all my IaC. 

I had also included the process of provisioning vm's to test out the base image configuration 
into terraform, and wrote an ansible inventory Python script that queries "terraform output" for the 
IP of the fresh machine to test the base iamge playbooks on. Which makes for a wonderful flow 
of tapping away at my ansible playbook, trying things out until something breaks, and being able 
to quickly delete and reprovision that VM, and immediately run a script to get me back to where
I was before I broke the VM. 


To be continued...