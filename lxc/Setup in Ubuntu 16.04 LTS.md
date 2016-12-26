# Установка LXC для Ubuntu 16.04 LTS

```
apt install lxc
systemctl disable lxd
systemctl disable lxd-bridge
systemctl enable lxc
systemctl enable lxc-net
```


## Настройка LXC

Изменяем настройки контейнера по умолчанию `nano /etc/lxc/default.conf`

```
# ----------------- Настройки -----------------

lxc.network.type = veth
lxc.network.flags = up
lxc.network.name = em0
lxc.network.link = lxcbr0
lxc.network.ipv4.gateway = 10.0.0.1
lxc.network.hwaddr = 00:16:3e:xx:xx:xx
lxc.id_map = u 0 100000 65536
lxc.id_map = g 0 100000 65536
```

Настраиваем сеть `nano /etc/default/lxc-net`:
```
USE_LXC_BRIDGE="true"
LXC_BRIDGE="lxcbr0"
LXC_BRIDGE_MAC="00:16:3e:00:00:00"
LXC_ADDR="10.0.0.1"
LXC_NETMASK="255.255.0.0"
LXC_NETWORK="10.0.0.0/16"
LXC_DHCP_RANGE="10.0.200.1,10.0.255.254"
LXC_DHCP_MAX="14333"
LXC_DHCP_CONFILE=""
LXC_DOMAIN=""
#LXC_DHCP_CONFILE=/etc/lxc/dnsmasq.conf
#LXC_DOMAIN="lxc"
```

Добавляем права доступа к папке
```
chmod 755 /var/lib/lxc
```


## Настройка UID/GID


Перед тем как запускать lxc убедитесь в правильной настройке файлов `/etc/subuid` и `/etc/subgid`. Для пользователей lxc и root должны быть выставлены следующие значения:


**less /etc/subuid**
```
lxc:100000:65536
lxd:100000:65536
root:100000:65536
```

**less /etc/subgid**
```
lxc:100000:65536
lxd:100000:65536
root:100000:65536
```

Если вдруг вы хотите поставить другие ID, то вы должны их поменять также в `/etc/lxc/lxc/default.conf`.


Также желательно создать пользователей:
```
groupadd lxc-root -g 100000
useradd lxc-root -g 100000 -u 100000 -M -r -d /dev/null
```
Это упростит работу с LXC и будет показывать человеческие значения для root контейнера.


**ВНИМАНИЕ!!!**
В Debian и Ubuntu UID отличаются. В Ubuntu 100 тыс, в Debian 1 млн.


## Перезагружаемся

Перед тем как создавать первый контейнер, нужно перезагрузится, чтобы UID и сеть корректно заработала.

```
init 6
```


# Материалы
1. https://github.com/lxc/lxc
2. https://wiki.ubuntu.com/LinuxContainers
3. https://www.claudiokuenzler.com/blog/517/install-lxc-from-source-ubuntu-14.04-trusty
 
