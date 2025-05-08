---
# provisioning_templates/kickstart_rhel9_soe.ks
#version=RHEL9
install
cdrom
lang en_AU.UTF-8
keyboard us
timezone Australia/Sydney --isUtc
network --bootproto=dhcp --device=eth0 --activate

# Replace with your hashed password for production
rootpw --iscrypted $6$sjAEcR$Bzi6BOKUeQuCD3QOQ.RYxVRXsMbQJZbEtwUbPXXqWswfWldMmtE8TRkxogqrBDZ3N0RRH9hdFlTzIKULhfEkG1 
authselect select sssd --force
selinux --enforcing
firewall --enabled --service=ssh

# Full disk encryption using a passphrase (replace "changeme" with a secure method in production)
# Preferred option is a prompted passphrase for an interactive install - so replace the following lines with these:
# replace changeme with blank passphrase to require manual entry at boot
# encrypt --encrypted
# volgroup rhel --encrypted sda

ignoredisk --only-use=sda
autopart --nohome
clearpart --all --initlabel
encrypt --passphrase=changeme --encrypted
logvol /boot --fstype=xfs --size=1024 --name=bootlv --vgname=rhel
logvol / --fstype=xfs --size=10240 --name=rootlv --vgname=rhel
logvol /home --fstype=xfs --size=2048 --name=homelv --vgname=rhel
logvol /tmp --fstype=xfs --size=2048 --name=tmplv --vgname=rhel
logvol /var --fstype=xfs --size=4096 --name=varlv --vgname=rhel
logvol /var/log --fstype=xfs --size=2048 --name=loglv --vgname=rhel
logvol /var/log/audit --fstype=xfs --size=1024 --name=auditlv --vgname=rhel
logvol /var/tmp --fstype=xfs --size=1024 --name=tmpvarlv --vgname=rhel
logvol /usr --fstype=xfs --size=4096 --name=usrlv --vgname=rhel
volgroup rhel --encrypted --passphrase=changeme sda

%packages
@core
chrony
rsync
sysstat
rsyslog
katello-agent
sos
lsof
traceroute
wget
insights-client
vim-enhanced
zip
unzip
%end

%post --log=/root/ks-post.log
systemctl enable auditd chronyd crond kdump oddjobd dbus rsyslog sshd tuned goferd
systemctl disable graphical.target
%end

%post
# Activate tuned profile
tuned-adm profile virtual-guest
%end

%post
# Register system with Satellite and enable Ansible callback
# Ensure the `bootstrap.py` URL and activation key are correct for your environment
/usr/bin/curl -sS https://satellite.example.com/pub/bootstrap.py | /usr/bin/python3 - \
  --activationkey=rhel9-soe-key \
  --org="YourOrg" \
  --location="YourLocation"
%end