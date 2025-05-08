# RHEL 9 SOE Roles for Red Hat Satellite

This repository contains modular Ansible roles to configure a Red Hat Enterprise Linux 9 Standard Operating Environment (SOE), designed for deployment through Red Hat Satellite.

## Roles Overview

- `ad_join`: Join to Active Directory domain
- `yubikey_setup`: Configure YubiKey with PAM U2F
- `ntp_config`: Chrony time sync with internal NTP
- `fapolicyd_config`: Custom rule for application whitelist
- `nessus_agent`: Download and enable Nessus agent
- `azure_agent`: Install Azure Linux agent
- `librenms_agent`: SNMP config for LibreNMS
- `veeam_agent`: Placeholder for Veeam installation

## Usage

Clone this repo and import it into Satellite:
```bash
git clone https://github.com/<your-org>/rhel9_soe.git
hammer ansible roles import --path rhel9_soe/roles/
```

## Prerequisites
Ensure
- The host(s) are registered to Satellite and belong to an appropriate Host Group.
- The katello-agent or remote execution (SSH-based) is functioning.
- foreman_ansible plugin is enabled in Satellite (usually default from 6.9+).



## Package the roles
```
cd ~/ansible-roles
tar czf rhel9_soe_roles.tar.gz rhel9_soe/
```

## Import into Satellite 
`hammer ansible roles import --path /path/to/rhel9_soe/`

## Assign to Host Group
Go to Hosts > Host Groups > RHEL9-SOE
Tab: Ansible Roles
Click Add Role, then add:
- `ad_join`
- `yubikey_setup`
- `ntp_config`
- `fapolicyd_config`
- `etc.`
Save

## Enable Remote Execution

Make sure you have:

- Remote Execution plugin installed and configured
- Smart Proxy Capsule with SSH or pull-mode
- SSH keys exchanged, or Capsule handles SSH

Test with:
`hammer job-invocation create --feature ansible --inputs='' --search 'hostgroup = "RHEL9-SOE"'`

## Run via Remote Execution
```
hammer job-invocation create \
  --feature ansible \
  --search "hostgroup = RHEL9-SOE"
```
