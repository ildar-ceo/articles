
## Скачиваем контейнер по умолчанию

```
lxc-create -t download -n test-centos -- -d centos -r 7 -a amd64
```

Скачается чистая версия контейнера centos 7.


**для Debian:**
```
lxc-create -t download -n test-debian -- -d debian -r jessie -a amd64
```

**для Ubuntu:**
```
lxc-create -t download -n test-ubuntu -- -d ubuntu -r xenial -a amd64
```


## Запуск тестового контейнера


Откройте файл `nano /var/lib/lxc/test-centos/config` и добавьте строчку:
```
lxc.network.ipv4 = 10.0.1.5/16
```
Это позволит привязать IP к контейнеру.

Теперь можно запустить контейнер командой `lxc-start --name test-centos`

Контейнер сразу должен быть отображен в `lxc-top`:
```
Container                   CPU          CPU          CPU          BlkIO        Mem
Name                       Used          Sys         User          Total       Used
test                       0.34         0.10         0.10        6.59 MB    0.00
TOTAL 1 of 1               0.34         0.10         0.10        6.59 MB    0.00
```

Делаем `lxc-attach --name test-centos`, чтобы зайти в контейнер

проверяем IP:
```
[root@test /]# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
4: em0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
    link/ether 00:16:3e:c6:69:24 brd ff:ff:ff:ff:ff:ff
```
	
	
## Настройка тестового контейнера

Еще можно контейнеру прописать некоторые параметры:


Запускать контейнер только на первых трех cpu:
```
lxc.cgroup.cpuset.cpus = 0,1,2
```

Назначить имя сетевого адаптера для этого контейнера на хостовой машине:
```
lxc.network.veth.pair = veth-containername
```

Имя хоста виртуальной машины:
```
lxc.utsname = containername
```

Автозапуск контейнера через 10 секунд после старта системы:
```
lxc.start.auto = 1
lxc.start.delay = 10
```
