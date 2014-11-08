.. title: Broken wifi after standby in Arch/Gnome
.. slug: broken-wifi-after-standby-in-archgnome
.. date: 2014-10-27 09:11:59 UTC+01:00
.. tags:
.. link:
.. description:
.. type: text

Write your post here.

.. code:: sh

	sudo systemctl kill NetworkManager.service
	sudo systemctl start NetworkManager.service