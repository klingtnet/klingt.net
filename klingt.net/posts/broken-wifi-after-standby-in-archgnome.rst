.. title: Broken wifi after standby in Arch/Gnome
.. slug: broken-wifi-after-standby-in-archgnome
.. date: 2014-10-27 09:11:59 UTC+01:00
.. tags: wifi, Arch, NetworkManager, Gnome, systemctl, systemd, fix
.. link:
.. description: Fixing wifi connection problem after standby
.. type: text

Sometimes my laptop can't connect to the wifi network after waking up from suspend. Furthermore the network icons are missing from Gnomes panel. Simply restarting the ``NetworkManager.service`` via ``systemctl`` doesn't help in most cases, but the following works for me:

.. code:: sh

	sudo systemctl kill NetworkManager.service wpa_supplicant.service
	sudo systemctl start NetworkManager.service wpa_supplicant.service