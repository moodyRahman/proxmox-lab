
apt install sudo cloud-init python
usermod -aG sudo moody
echo "moody ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers >/dev/null && sudo visudo -cf /etc/sudoers