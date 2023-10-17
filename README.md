# Kafka Cluster Provisioning on GCP with Terraform & Ansible

This repository allows you to effortlessly set up a Kafka cluster on Google Cloud Platform (GCP) using Compute Engine VMs. The provisioning uses Terraform for VM creation and Ansible for broker configuration.

## Overview

**Terraform** is responsible for:
- Creating GCP Compute Engine Instances as described in `main.tf`.
    - The number of brokers is determined by the `count` variable.
    - The machine type used is `e2-standard-2`, which comes with 2 vCPUs and 8GB RAM.

**Bash Script** performs:
- Parsing the output from Terraform using `jq` to extract both external and internal IP addresses of the provisioned VMs.
- Creating a `hosts.ini` inventory file for Ansible.

**Ansible Playbook** manages:
- Java installation.
- Kafka download and setup on each VM.
- Configuration of Zookeeper and Kafka broker, adhering to the defined Jinja2 templates.
- Creation of systemd units, enabling Kafka and Zookeeper to run as daemons.

## Setup Guide

### 1. Setting up SSH

GCP's OS Login feature allows for SSH login into VMs using a public SSH key linked to your Google account. Here’s how to set it up:

1. Generate a key pair:

```bash
ssh-keygen -t rsa -b 2048 -f ~/.ssh/gcp_os_login
```

2. Associate the public key with your Google account:

```bash
gcloud compute os-login ssh-keys add \
   --key-file=$HOME/.ssh/gcp_os_login.pub \
   --project=YOUR_PROJECT_NAME \
   --ttl=60d
```
Replace `YOUR_PROJECT_NAME` with your project's name.

### 2. Cluster Setup

1. Begin by provisioning the VMs via Terraform:

```bash
terraform init
terraform plan
terraform apply -auto-approve
```

2. Execute the Bash script to create the `hosts.ini` inventory file:

```bash
./create_hosts_file.sh
```

3. Finally, run the Ansible playbook:

```bash
ansible-playbook -i hosts.ini kafka-setup.yaml -u YOUR_USERNAME_DOMAIN_SUFFIX
```
Replace `YOUR_USERNAME_DOMAIN_SUFFIX` with your actual username domain suffix.

---

And that's it! You should now have a Kafka cluster running on GCP Compute Engine VMs.

