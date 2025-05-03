#!/bin/bash

ansible-playbook \
	-i ~/git/CSE-41379/ansible/inventory.ini \
	--user ec2-user \
	--private-key=~/.ssh/cse41379.pem \
	~/git/CSE-41379/ansible/setup_linux.yaml

ansible-playbook \
	-i ~/git/CSE-41379/ansible/inventory.ini \
	--user ec2-user \
	--private-key=~/.ssh/cse41379.pem \
	~/git/CSE-41379/ansible/install_jenkins.yaml

ansible-playbook \
	-i ~/git/CSE-41379/ansible/inventory.ini \
	--user ec2-user \
	--private-key=~/.ssh/cse41379.pem \
	~/git/CSE-41379/ansible/install_sonarqube.yaml
