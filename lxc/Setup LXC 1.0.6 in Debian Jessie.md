# Установка LXC для Debian Jessie 8


**Внимание!!!**

Последние версии LXC 2 не работают в Debian, можете их не компилировать. Работают только в Ubuntu 16.04 LTS и выше.
Подробнее здесь: https://github.com/lxc/lxc/issues/1362

Пользуйтесь теми версиями, что есть в официальном репозитории Debian. На 21 декабря 2016г версия LXC в Debian: 1.0.6-6.

**Совет:** лучше используйте Ubuntu 16.04, или на крайняк Centos 7. LXC 1.0.6 работает как то странно. А также не работают непривелигированные контейнеры.


Установка LXC:
```
apt install lxc bridge-utils
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
lxc.id_map = u 0 1000000 65536
lxc.id_map = g 0 1000000 65536
```


## Настройка UID/GID

Для LXC 1.0.6 не работают непривелигированные контейнеры. 
Вобще LXC 1.0.6 какой то странный :(.
Ставьте Ubuntu 16.04 LTS.


## Настройка сети

Сеть придется настраивать ручками :(.


Выполняем скрипт nat.sh:
```
wget https://raw.githubusercontent.com/vistoyn/articles/master/lxc/nat.sh -O "./nat.sh"
/bin/bash ./nat.sh
```

Открываем `nano /etc/rc.local` и пишем там:
```
brctl addbr lxcbr0
ifconfig lxcbr0 up
ifconfig lxcbr0 10.0.0.1 netmask 255.255.0.0 up
iptables-restore < /etc/default/iptables
#service libvirtd start
```

Добавляем флаг:
```
chmod +x /etc/rc.local
```


# Разрешаем проброс портов
```
echo 1 > /proc/sys/net/ipv4/ip_forward
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
```



## Перезагружаемся

Перед тем как создавать первый контейнер, нужно перезагрузится, чтобы UID и сеть корректно заработала.

```
init 6
```


# Материалы
1. https://github.com/lxc/lxc
2. https://wiki.ubuntu.com/LinuxContainers
3. https://www.claudiokuenzler.com/blog/517/install-lxc-from-source-ubuntu-14.04-trusty
 
