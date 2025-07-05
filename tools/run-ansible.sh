#!/bin/bash
#
#ansible-playbook \
#	-i ~/git/CSE-41379/ansible/inventory.ini \
#	--user ec2-user \
#	--private-key=~/.ssh/cse41379.pem \
#	~/git/CSE-41379/ansible/setup_linux.yaml
#

ansible-playbook \
	-i ~/git/CSE-41379/ansible/inventory.ini \
	--user ec2-user \
	--private-key=~/.ssh/cse41379.pem \
	--extra-vars "$( (cd ~/git/CSE-41379/terraform && terraform output --json ) | jq 'with_entries(.value |= .value)')" \
	~/git/CSE-41379/ansible/install_jenkins.yaml

#ansible-playbook \
#	-i ~/git/CSE-41379/ansible/inventory.ini \
#	--user ec2-user \
#	--private-key=~/.ssh/cse41379.pem \
#	~/git/CSE-41379/ansible/install_executors.yaml
#
#ansible-playbook \
#	-i ~/git/CSE-41379/ansible/inventory.ini \
#	--user ec2-user \
#	--private-key=~/.ssh/cse41379.pem \
#	~/git/CSE-41379/ansible/install_sonarqube.yaml

#ansible-playbook \
#	-i ~/git/CSE-41379/ansible/inventory.ini \
#	--user ec2-user \
#	--private-key=~/.ssh/cse41379.pem \
#	~/git/CSE-41379/ansible/install_nexus.yaml
#
#
#
