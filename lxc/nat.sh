# Чистим iptables. Тоже опционально
iptables -F
iptables -t nat -F
iptables -t mangle -F

iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -p icmp -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT

# Разрешаем DHCP и DNS для контейнеров
iptables -A INPUT -i lxcbr0 -p tcp -m tcp --dport 53 -j ACCEPT
iptables -A INPUT -i lxcbr0 -p udp -m udp --dport 53 -j ACCEPT
iptables -A INPUT -i lxcbr0 -p tcp -m tcp --dport 67 -j ACCEPT
iptables -A INPUT -i lxcbr0 -p udp -m udp --dport 67 -j ACCEPT

# Опционально. Разрешить входящие соединения на 80 порт
iptables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT

# Разрешить SSH
iptables -A INPUT -p tcp -m state --state NEW -m tcp --dport 22 -j ACCEPT

# Добавляем FORWARD для lxcbr0
iptables -A FORWARD -o lxcbr0 -j ACCEPT
iptables -A FORWARD -i lxcbr0 -j ACCEPT
iptables -A INPUT -j REJECT --reject-with icmp-host-prohibited
iptables -A FORWARD -j REJECT --reject-with icmp-host-prohibited

# Настройка NAT для сети 10.0.0.0/16
iptables -t nat -A POSTROUTING -s 10.0.0.0/16 ! -d 10.0.0.0/16 -j MASQUERADE

# Опционально. Разрешить проброс портов
#iptables -t nat -A PREROUTING -p tcp --dport 22011 -j DNAT --to-destination 10.0.0.11:22


# Сохраняем iptables
iptables-save > /etc/default/iptables
