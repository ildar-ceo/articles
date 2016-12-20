# Установка LXC для Debian Jessie 8


**Внимание!!!**
Последние версии LXC 2 не работают в Debian, можете их не компилировать. Работают только в Ubuntu 16.04 LTS и выше.
Пользуйтесь теми версиями, что есть в официальном репозитории Debian.
На 21 декабря 2016г версия LXC в Debian: 1.0.6-6.


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


Перед тем как запускать lxc убедитесь в правильной настройке файлов `/etc/subuid` и `/etc/subgid`. Для пользователей lxc и root должны быть выставлены следующие значения:


**less /etc/subuid**
```
lxc:1000000:65536
root:1000000:65536
```

**less /etc/subgid**
```
lxc:1000000:65536
root:1000000:65536
```

Если вдруг вы хотите поставить другие ID, то вы должны их поменять также в `/etc/lxc/default.conf`.


Также желательно создать пользователей:
```
groupadd lxc-root -g 1000000
useradd lxc-root -g 1000000 -u 1000000 -M -r -d /dev/null
```
Это упростит работу с LXC и будет показывать человеческие значения для root контейнера.


**ВНИМАНИЕ!!!**
В Debian и Ubuntu UID отличаются. В Ubuntu 100 тыс, в Debian 1 млн.



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



Почему я использую маску 16, а не 24. Это такой лайхак, чтобы путаницы с IP было меньше в облачных системах.

Контейнеров может быть много. Они могут быть установлены на разных хостах. А еще есть всякие virtualbox и qemu. И конфиг контейнера тоже перемещается с машины на машину. А еще есть VPN.

Так вот удобно юзать одинаковые уникальные ip адреса для контейнеров в облачной системе или если у вас несколько серваков.

По крайне мере есть некая гарантия что свежий контейнер не будет конфликтовать с другим контейнером по IP.

Можно также зеркалить IP с VPN IP. Например, 10.0.30.60 - это локальный IP, а 10.50.30.60 - это VPN IP. И всегда можно отняв 50 получить локальный IP и наоборот.

А в системе VPN IP должны быть уникальными.

**Сети:**
```
10.0.0.0/16 - Сеть LXC
10.50.0.0/16 - Сеть Open VPN
10.200.0.0/16 - Сеть LXD
```

**P.S.** В LXC настроен DHCP в диапазоне 10.0.200.1 - 10.0.255.254


## Перезагружаемся

Перед тем как создавать первый контейнер, нужно перезагрузится, чтобы UID и сеть корректно заработала.

```
init 6
```


# Материалы
1. https://github.com/lxc/lxc
2. https://wiki.ubuntu.com/LinuxContainers
3. https://www.claudiokuenzler.com/blog/517/install-lxc-from-source-ubuntu-14.04-trusty
 
