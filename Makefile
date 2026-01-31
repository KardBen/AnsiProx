setup:
	ansible-galaxy install -r requirements.yml --force

run:
	ansible-playbook pb_deploy.yaml