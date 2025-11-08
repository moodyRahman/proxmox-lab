#! /bin/bash
apt install cloud-guest-utils
growpart /dev/sda 1
pvresize /dev/sda1
lvextend -r -l +100%FREE /dev/base/root