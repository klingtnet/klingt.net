.PHONY: vm vagrant clean clean-all

APPS:=$(dir $(wildcard build/*/))

all: vm

vm: vagrant
	ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook\
		--private-key='./.vagrant/machines/default/virtualbox/private_key'\
		--inventory-file='./.vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory'\
		--verbose\
		playbook.yml

vagrant:
	vagrant up

clean:
	vagrant destroy -f
	rm -f *.retry

clean-all: clean
	@for app in $(APPS); do\
		make -C "$$app" clean &> /dev/null;\
	done
