# Motd Ubuntu
![img](https://github.com/sumshiiy/ubuntu-motd/blob/main/ubuntu.png?raw=true)
```bash
$ sudo apt install figlet
$ sudo chmod -x /etc/update-motd.d/*
$ sudo nano /etc/update-motd.d/00-custom
$ Paste file from login.sh
$ sudo chmod +x /etc/update-motd.d/00-custom
```

Relogin


## one command
```bash
$ curl -O https://raw.githubusercontent.com/sumshiiy/ubuntu-motd/refs/heads/main/lama.sh | bash lama.sh
```
