# Процесс установки

```
yum install mysql-devel ImageMagick-devel ImageMagick-c++-devel
```

Ставим RVM:

```
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
\curl -sSL https://get.rvm.io | bash -s stable
```

Если не работаеть команда `rvm`, то в /etc/bash.bashrc нужно прописать строчку
```
source /etc/profile.d/rvm.sh
```


Чтобы увидеть доступные версии ruby выполните команду:
```
rvm list known
```


Установите нужную версию ruby. Узнать какая версия нужна для редмайна можно здесь http://www.redmine.org/projects/redmine/wiki/RedmineInstall
```
rvm install 2.3
```


Качаем Redmine версии 3.3
```
mkdir -p /opt 
cd /opt
hg clone --updaterev 3.3-stable https://bitbucket.org/redmine/redmine-all redmine-3.3
```


Создаем файл 
```
nano /etc/init.d/redmine
```
И вставляем туда содержимое файла [...]

Назначаем права
```
chmod +x /etc/init.d/redmine
```

Добавляем пользователя
```
groupadd -g 403 -r redmine
useradd -g 403 -u 403 -s /bin/bash -M redmine -d /home/redmine
usermod -a -G wheel redmine
```

Нужно удостовериться что redmine доступен sudo без пароля


Создаем БД и пользователя redmine в MySql и даем ему доступ к этой таблице

Переходим в папку со скачанным редмайном
```
cd /opt/redmine-3.3
```


Копируем файл настройки БД
```
cp /opt/redmine-3.3/config/database.yml.example /opt/redmine-3.3/config/database.yml
chown -R redmine:redmine  /opt/redmine-3.3
```

Copy config/database.yml.example to config/database.yml and edit this file in order to configure your database settings for "production" environment.


Окрываем файл на редактирование
```
nano /opt/redmine-3.3/config/database.yml
```

меняем секци production
```
production:
  adapter: mysql2
  database: redmine
  host: localhost
  port: 3306
  username: redmine
  password: my_password
  encoding: utf8
```

Устанавливаем bundler
```
gem install bundler
```

Устанавливаем зависимости
```
su redmine
source /etc/profile.d/rvm.sh
bundle install --without development test
```

Сгенерировать секретный токен
```
bundle exec rake generate_secret_token
```

Установить базу данных
```
RAILS_ENV=production bundle exec rake db:migrate
RAILS_ENV=production bundle exec rake redmine:load_default_data
```

Изменим файл
```
nano /etc/bashrc
```

Добавим в конец:
```
#PATH=$PATH:/usr/local/rvm/bin
rvm use ruby-2.3.0 > /dev/null 2>&1
```

Делаем
```
service redmine start
```


# Материалы

1. [Ruby Version Manager (RVM)](https://rvm.io/)
1. [Установка Redmine на английском](http://www.redmine.org/projects/redmine/wiki/RedmineInstall)
1. [Установка Redmine на русском](http://www.redmine.org/projects/redmine/wiki/RusRedmineInstall)
1. http://www.hiddentao.com/archives/2008/12/06/redmine-svn-mysql-5-lighttpd-15/
1. http://habrahabr.ru/post/225667/
1. http://seriyps.ru/blog/2010/01/14/ustanovka-redmine-na-ubuntu-9-10-pod-nginx/
1. http://www.redmine.org/projects/redmine/wiki/HowTo_configure_Nginx_to_run_Redmine
1. http://firstwiki.ru/index.php/%D0%A3%D1%81%D1%82%D0%B0%D0%BD%D0%BE%D0%B2%D0%BA%D0%B0_redmine_%D0%BD%D0%B0_centos
1. http://www.redmine.org/projects/redmine/wiki/HowTo_configure_Apache_to_run_Redmine
1. http://redmine.webtoolkit.eu/projects/wt/wiki/Fastcgi_on_nginx 
