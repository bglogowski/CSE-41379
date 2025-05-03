#!/bin/bash

cd ~/git/CSE-41379/terraform
terraform plan && terraform apply
cd -
~/git/CSE-41379/tools/run-ansible.sh

