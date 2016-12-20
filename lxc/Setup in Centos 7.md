# Установка LXC для Debian Jessie 8


**Внимание!!!**
На Centos 7 не работают непривелигированные контейнеры из-за того что ядро там слишком старое.


Установка LXC:
```
wget https://github.com/vistoyn/lxc-compile/releases/download/1.1.0-centos/lxc-1.1.0-1.20160505.el7.centos.x86_64.tar.bz2
tar xvf ./lxc-1.1.0-1.20160505.el7.centos.x86_64.tar.bz2
cd lxc-1.1.0
./install-iptables.sh
./install.sh
```

Все :)


## Перезагружаемся

Перед тем как создавать первый контейнер, нужно перезагрузится, чтобы UID и сеть корректно заработала.

```
init 6
```

 
