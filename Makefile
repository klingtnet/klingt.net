.PHONY: vm vagrant clean clean-all

APPS:=$(dir $(wildcard build/*/))
ANSIBLE_OPTS="--vault-password-file=./vault.pass"

all: vm

vm: playbook.yml Vagrantfile vagrant
	ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook $(ANSIBLE_OPTS)\
		--extra-vars='var_domain="klingt.vnet"'\
		--private-key='./.vagrant/machines/default/virtualbox/private_key'\
		--inventory-file='./.vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory'\
		--verbose\
		playbook.yml

klingt.net: playbook.yml Vagrantfile
	ansible-playbook $(ANSIBLE_OPTS)\
		--vault-password-file='./vault.pass'\
		--verbose\
		playbook.yml

vagrant:
	vagrant up

clean:
	rm -f *.retry

clean-vm:
	vagrant destroy -f

clean-all: clean clean-vm
	@for app in $(APPS); do\
		make -C "$$app" clean &> /dev/null;\
	done
