# Настройка личного сертификата SSH


Делаем `ssh-keygen`

```
Generating public/private rsa key pair.
Enter file in which to save the key (/home/user/.ssh/id_rsa):
```

Нажимает просто `Enter`

Если спросит, перезаписать сертификат? То сертификат уже есть. Если он вам нужен, то сделайте бэкап, сохраните его куданибудь. Если не нужен, то перезатирайте.
```
/home/user/.ssh/id_rsa already exists.
Overwrite (y/n)? y
```

Введите свой пароль от ~всех дверей~ сертификата:
```
Enter passphrase (empty for no passphrase):
```

Повторите ввод пароля.
```
Enter same passphrase again:
```


# Настройка ssh клиента

Создайте файл `nano ~/.ssh/config` со следующим содержимым:

```
Host *
	Protocol 2
	KeepAlive yes
	TCPKeepAlive yes
	ServerAliveInterval 60
	ServerAliveCountMax 3
	Compression yes
	CompressionLevel 9
	#ForwardX11 yes
	UseRoaming no
	
Host my_host
	Hostname 127.0.0.1
	User my_username
	Port 22	
```

Вместо my_host и my_username укажите реальные данные. Таких хостов вы можете создаст много.

Скопируйте публичный ключ на удаленный сервер:
```
ssh-copy-id my_host
```
Введите пароль от сервера ssh, к которому вы подключаетесь.

Теперь вы можете заходить на этот сервер, через ssh по команде, введя свой пароль от сертификата:
```
ssh my_host
```
