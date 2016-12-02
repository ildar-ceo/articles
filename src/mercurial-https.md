# Mercurial и Https

Чтобы заработал Mercurial по https нужно:

##  для Centos 6

Устанавливаем корневые сертификаты. Выполняем комманды под рутом
```bash
yum install ca-certificates
update-ca-trust force-enable
```


Устанавливаем сертификаты от letsencrypt
```bash
wget https://letsencrypt.org/certs/lets-encrypt-x1-cross-signed.pem -O"/etc/pki/ca-trust/source/anchors/lets-encrypt-x1-cross-signed.pem"
wget https://letsencrypt.org/certs/lets-encrypt-x2-cross-signed.pem -O"/etc/pki/ca-trust/source/anchors/lets-encrypt-x2-cross-signed.pem"
wget https://letsencrypt.org/certs/lets-encrypt-x3-cross-signed.pem -O"/etc/pki/ca-trust/source/anchors/lets-encrypt-x3-cross-signed.pem"
wget https://letsencrypt.org/certs/lets-encrypt-x4-cross-signed.pem -O"/etc/pki/ca-trust/source/anchors/lets-encrypt-x4-cross-signed.pem"
```

Собираем сертификаты
```bash
update-ca-trust extract
```

##  Для Ubuntu

Устанавливаем сертификаты от letsencrypt
```bash
wget https://letsencrypt.org/certs/lets-encrypt-x1-cross-signed.pem -O"/usr/local/share/ca-certificates/lets-encrypt-x1-cross-signed.crt"
wget https://letsencrypt.org/certs/lets-encrypt-x2-cross-signed.pem -O"/usr/local/share/ca-certificates/lets-encrypt-x2-cross-signed.crt"
wget https://letsencrypt.org/certs/lets-encrypt-x3-cross-signed.pem -O"/usr/local/share/ca-certificates/lets-encrypt-x3-cross-signed.crt"
wget https://letsencrypt.org/certs/lets-encrypt-x4-cross-signed.pem -O"/usr/local/share/ca-certificates/lets-encrypt-x4-cross-signed.crt"
```

Собираем сертификаты
```bash
update-ca-certificates
```

##  Настройка php и hg

Прописываем сертификаты в php. Выполняем комманду `sudo nano /etc/php.d/openssl.ini`
```
openssl.cafile="/etc/ssl/certs/ca-bundle.crt" 
openssl.capath="/etc/ssl/certs/"
```

Создаем файл nano ~/.hgrc под аккаунтом www и вставляем содержимое. Вместо текста в <> вставляйте ваше данные
```
[ui]
username=<ваше имя пользователя>

[auth]
<myserver_alias>.prefix = https://<myserver_domain_name>/
<myserver_alias>.username = <логин>
<myserver_alias>.password = <пароль>

[defaults]
push =  -v -f --debug
pull =  -v --debug
commit =  -v --debug

[hostfingerprints]
<myserver_domain_name> = 00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00


#[web]
#cacerts = /etc/ssl/certs/ca-bundle.crt
```
