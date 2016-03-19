{
    "date": "2014-10-27",
    "description": "Hot to fix the wifi connection problem after standby.",
    "slug": "broken-wifi-after-standby-in-archgnome",
    "tags": "wifi, Arch, NetworkManager, Gnome, systemctl, systemd, fix",
    "title": "Broken wifi after standby in Arch/Gnome"
}

Sometimes my laptop can't connect to the wifi network after waking up
from suspend. Furthermore the network icons are missing from Gnomes
panel. Simply restarting the `NetworkManager.service` via `systemctl`
doesn't help in most cases, but the following works for me:

``` {.sourceCode .sh}
sudo systemctl kill NetworkManager.service wpa_supplicant.service
sudo systemctl start NetworkManager.service wpa_supplicant.service
```
