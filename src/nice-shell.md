# Причесываем консоль Ubuntu

Для того, чтобы Ubuntu консоль выглядела чуть красивее, можно скачать готовые скрипты.

*Под рутом:*
```
wget https://github.com/vistoyn/nice_shell/raw/master/profile.d/welcome.sh -O "/etc/profile.d/welcome.sh"
wget https://github.com/vistoyn/nice_shell/raw/master/profile.d/lib.sh -O "/etc/profile.d/lib.sh"
```

*Под каждым пользователем:*
```
wget https://github.com/vistoyn/nice_shell/raw/master/ubuntu/.profile -O ~/.profile
wget https://github.com/vistoyn/nice_shell/raw/master/ubuntu/.bashrc -O ~/.bashrc
```

Эти скрипты устанавливают приветствие командной строки: красное для рута, синее для обычного пользователя и добавляют WELCOME_NAME. В /etc/profile.d/welcome.sh можно поменять переменную WELCOME_NAME на свою.
Также эти скрипты добавляют функции:
* ff <имя файла> - поиск файла в текущей директории;
* fe <строка> - поиск по содержимому в файлах текущей директории;
* myip – текущий ip;
* ii – расширенная информация о системе;



