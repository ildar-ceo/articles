# Настройка сертификата Let's Encrypt 

```
service nginx stop
letsencrypt certonly -d my_host --email my_email --text
service nginx start
```


Генерируем ключ:
```
openssl dhparam -out /etc/letsencrypt/live/my_host/dhparam.pem 4096
```


# Nginx

Вставляем строчки в раздел http nginx.conf
```
    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;
    keepalive_timeout   70;
    types_hash_max_size 2048;


    ssl_session_cache   shared:SSL:10m;
    ssl_session_timeout 5m;
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2; # Dropping SSLv3, ref: POODLE
    ssl_stapling on;
	
    # Cерверные шифры имеют больший приоритет, чем клиентские шифры
    ssl_prefer_server_ciphers on;
	
    # Разрешённые шифры
    ssl_ciphers 'ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:ECDHE-RSA-DES-CBC3-SHA:ECDHE-ECDSA-DES-CBC3-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:AES:CAMELLIA:DES-CBC3-SHA:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!MD5:!PSK:!aECDH:!EDH-DSS-DES-CBC3-SHA:!EDH-RSA-DES-CBC3-SHA:!KRB5-DES-CBC3-SHA';
    #ssl_ciphers kEECDH+AES128:kEECDH:kEDH:-3DES:kRSA+AES128:kEDH+3DES:DES-CBC3-SHA:!RC4:!aNULL:!eNULL:!MD5:!EXPORT:!LOW:!SEED:!CAMELLIA:!IDEA:!PSK:!SRP:!SSLv2;
    #ssl_ciphers         HIGH:!aNULL:!MD5;
    

    # Разрешаем серверу для валидации сертификата прикреплять OCSP-ответы
    #ssl_stapling on;
    #ssl_stapling_verify on;
    #ssl_trusted_certificate /etc/pki/tls/certs/ca-bundle.crt;
    #resolver 8.8.8.8 [2001:4860:4860::8888];

    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;

    client_max_body_size 256m;
    charset  utf-8;
    gzip  on;
    index   index.php index.html index.htm;

```


Для домена делаем:

```
server {
    listen 80;
    server_name my_host;
    rewrite ^(.*)$ https://$server_name$1 permanent;
}


server {
	listen       443 ssl;
	server_name  my_host;
	root         /var/html/;

	ssl_certificate     /etc/letsencrypt/live/my_host/cert.pem;
	ssl_certificate_key /etc/letsencrypt/live/my_host/privkey.pem;
	ssl_dhparam /etc/letsencrypt/live/my_host/dh4096.pem;
	
  # Сайт доступен только по https
  #add_header Strict-Transport-Security 'max-age=604800';
  
  # Запретить показывать сайт во фрейме11
  add_header X-Frame-Options DENY;
  
  # Использовать отданный сервером Сontent-type, вместо автоматического его определения
  add_header X-Content-Type-Options nosniff;
  
  # Активировать XSS-защиту:
  add_header X-XSS-Protection "1; mode=block";	
	
	location / {
		proxy_pass                          http://10.0.0.1/; # http proxy to 10.0.0.1:80
		proxy_set_header Host               $host;
		proxy_set_header X-Real-IP          $remote_addr;
		proxy_set_header X-Forwarded-For    $remote_addr;
		proxy_set_header SERVER_PROTOCOL    $server_protocol;
		proxy_set_header SERVER_PORT        $server_port;
		proxy_set_header SERVER_NAME        $server_name;
		proxy_set_header REMOTE_USER        $remote_user;
		proxy_set_header REMOTE_PORT        $remote_port;
		proxy_set_header HTTPS              $https;
		proxy_set_header REQUEST_URI        $request_uri;
		proxy_set_header SCRIPT_NAME        /redmine;
		proxy_set_header QUERY_STRING       $query_string;
	}
	
	
```


# Обновление сертификата LetsEncrypt

```
service nginx stop
letsencrypt renew
service nginx start
```



# Материалы

1. https://habrahabr.ru/post/252821/
2. https://spdycheck.org/ - SPDY Check
3. https://www.ssllabs.com/ssltest/index.html - проверка качества защиты вашего сервера.
