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
