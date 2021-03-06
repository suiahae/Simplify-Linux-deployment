# some useful systemctl files

`sudo systemctl daemon-reload`

## 1.aria2c

`sudo vim /usr/lib/systemd/system/aria2.service`

```bash
[Unit]
Description=A utility for downloading files which supports HTTP(S), FTP, SFTP, BitTorrent and Metalink
Wants=clash.service
After=clash.service

[Service]
Type=simple
User=minux
ExecStart=/usr/bin/aria2c --enable-rpc=true --disable-ipv6 --check-certificate=false --all-proxy="http://127.0.0.1:7890" --conf-path=/home/minux/.config/aria2/aria2.conf

[Install]
WantedBy=multi-user.target
```

## 2.yacd

`sudo vim /usr/lib/systemd/system/yacd-poweredby-docker_compose.service`

```bash
[Unit]
Description=Start yacd (Yet Another Clash Dashboard) auto
Wants=clash.service
After=clash.service

[Service]
Type=simple
User=minux
ExecStart=/usr/bin/docker-compose -f /home/minux/Programs/yacd/docker-compose.yaml up -d

[Install]
WantedBy=multi-user.target
```

## 3.rclone

### 3.1 movies

`sudo vim /usr/lib/systemd/system/rclone-movies.service`

GDTeam_raye_movies

```bash
[Unit]
Description=Rclone mount gdteam movies
Wants=clash.service
After=clash.service

[Service]
Type=simple
User=minux
Environment="HTTPS_PROXY=http://127.0.0.1:7890"
ExecStart=/bin/rclone mount GDTeam_raye_movies: /home/emby/GDTeam_raye_movies --allow-other --allow-non-empty

[Install]
WantedBy=multi-user.target
```

#### 3.2.2 movies --user

`vim /home/minux/.config/systemd/user/rclone-movies.service`

systemctl --user daemon-reload

```
[Unit]
Description=Rclone mount gdteam movies
Wants=clash.service
After=clash.service

[Service]
Type=simple
Environment="HTTPS_PROXY=http://127.0.0.1:7890"
ExecStart=/bin/rclone mount GDTeam_raye_movies: /home/emby/GDTeam_raye_movies --allow-other --allow-non-empty

[Install]
WantedBy=default.target
```

### 3.2 qinse

`sudo vim /usr/lib/systemd/system/rclone-qinse.service`

GDTeam_raye_qinse

```bash
[Unit]
Description=Rclone mount gdteam qinse
Wants=clash.service
After=clash.service

[Service]
Type=simple
User=minux
Environment="HTTPS_PROXY=http://127.0.0.1:7890"
ExecStart=/bin/rclone mount GDTeam_raye_qinse: /home/emby/GDTeam_raye_qinse --allow-other --allow-non-empty

[Install]
WantedBy=multi-user.target
```

#### 3.2.2 qinse --user

`vim /home/minux/.config/systemd/user/rclone-qinse.service`

systemctl --user daemon-reload

```
[Unit]
Description=Rclone mount gdteam qinse
Wants=clash.service
After=clash.service

[Service]
Type=simple
Environment="HTTPS_PROXY=http://127.0.0.1:7890"
ExecStart=/bin/rclone mount GDTeam_raye_qinse: /home/emby/GDTeam_raye_qinse --allow-other --allow-non-empty

[Install]
WantedBy=default.target
```

### 3.3 sundries

`sudo vim /usr/lib/systemd/system/rclone-sundries.service`

GDTeam_raye_sundries

```bash
[Unit]
Description=Rclone mount gdteam sundries
Wants=clash.service
After=clash.service

[Service]
Type=simple
User=minux
Environment="HTTPS_PROXY=http://127.0.0.1:7890"
ExecStart=/bin/rclone mount GDTeam_raye_sundries: /home/emby/GDTeam_raye_sundries --allow-other --allow-non-empty

[Install]
WantedBy=multi-user.target
```

#### 3.3.2 sundries --user

`vim /home/minux/.config/systemd/user/rclone-sundries.service`

systemctl --user daemon-reload

```
[Unit]
Description=Rclone mount gdteam sundries
Wants=clash.service
After=clash.service

[Service]
Type=simple
Environment="HTTPS_PROXY=http://127.0.0.1:7890"
ExecStart=/bin/rclone mount GDTeam_raye_sundries: /home/emby/GDTeam_raye_sundries --allow-other --allow-non-empty

[Install]
WantedBy=default.target
```

## 4. vnc

`/home/<USER>/.config/systemd/user/vncserver-<username>.service`

```
[Unit]
Description=Remote desktop service (VNC) for <USER>
After=syslog.target network.target

[Service]
Type=simple
ExecStart=/usr/bin/x0vncserver -display :1 -passwordfile /home/<username>/.vnc/passwd -Geometry 1920x1080 -localhost
Restart=on-failure
RestartSec=5s

[Install]
WantedBy=graphical-session.target
```

**Note:**

为使 systemd-user-service 可以开机运行，需要以管理员身份启用此功能。[参考](https://serverfault.com/questions/739451/systemd-user-service-doesnt-autorun-on-user-login)

```
sudo loginctl enable-linger <username>
```

## clash

See on <https://github.com/suiahae/clash-premium-installer>

<!-- 
`sudo vim /etc/systemd/system/start-docker-compose-clash.service`

```bash
[Unit]
Description=Start clash auto
After=docker.service

[Service]
Type=simple
User=minux
ExecStart=/usr/bin/docker-compose -f /home/minux/Programs/Clash/docker-compose.yaml up -d

[Install]
WantedBy=multi-user.target
​``` 
-->

```


