# Mercurial и Https


Чтобы заработал Mercurial по https нужно:


Устанавливаем корневые сертификаты. Выполняем комманды под рутом
```bash
sudo yum install ca-certificates
sudo update-ca-trust force-enable
```


Устанавливаем сертификаты от letsencrypt
```bash
sudo wget https://letsencrypt.org/certs/lets-encrypt-x1-cross-signed.pem -O"/etc/pki/ca-trust/source/anchors/lets-encrypt-x1-cross-signed.pem​"
sudo wget https://letsencrypt.org/certs/lets-encrypt-x2-cross-signed.pem -O"/etc/pki/ca-trust/source/anchors/lets-encrypt-x2-cross-signed.pem​"
sudo wget https://letsencrypt.org/certs/lets-encrypt-x3-cross-signed.pem -O"/etc/pki/ca-trust/source/anchors/lets-encrypt-x3-cross-signed.pem​"
sudo wget https://letsencrypt.org/certs/lets-encrypt-x4-cross-signed.pem -O"/etc/pki/ca-trust/source/anchors/lets-encrypt-x4-cross-signed.pem​"
```

Собираем сертификаты
```bash
update-ca-trust extract
```

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
<myserver>.prefix = https://<myserver>/
<myserver>.username = <логин>
<myserver>.password = <пароль>

[defaults]
push =  -v -f --debug
pull =  -v --debug
commit =  -v --debug

[hostfingerprints]
<myserver> = 00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00


#[web]
#cacerts = /etc/ssl/certs/ca-bundle.crt
```