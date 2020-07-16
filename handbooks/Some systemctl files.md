### 1.clash

`sudo vim /etc/systemd/system/start-docker-compose-clash.service`

```
[Unit]
Description=Start clash auto
Before=docker

[Service]
Type=simple
User=minux
ExecStart=/usr/bin/docker-compose -f /home/minux/Programs/Clash/docker-compose.yaml up -d

[Install]
WantedBy=multi-user.target
```

### 2.yacd

`sudo vim /usr/lib/systemd/system/start-docker-compose-yacd.service`

```
[Unit]
Description=Start yacd(Yet Another Clash Dashboard) auto
Before=start-docker-compose-clash.service

[Service]
Type=simple
User=minux
ExecStart=/usr/bin/docker-compose -f /home/minux/Programs/yacd/docker-compose.yaml up -d

[Install]
WantedBy=multi-user.target
```

### 3.rclone

#### 3.1 movies

`sudo vim /usr/lib/systemd/system/rclone-movies.service`

GDTeam_raye_movies

```
[Unit]
Description=Rclone mount gdteam movies
Before=start-docker-compose-clash.service

[Service]
Type=simple
User=minux
Environment="HTTPS_PROXY=http://127.0.0.1:7890" 
ExecStart=/bin/rclone mount GDTeam_raye_movies: /home/emby/GDTeam_raye_movies --allow-other --allow-non-empty

[Install]
WantedBy=multi-user.target
```

#### 3.2 qinse

`sudo vim /usr/lib/systemd/system/rclone-qinse.service`

GDTeam_raye_qinse

```
[Unit]
Description=Rclone mount gdteam qinse
Before=start-docker-compose-clash.service

[Service]
Type=simple
User=minux
Environment="HTTPS_PROXY=http://127.0.0.1:7890" 
ExecStart=/bin/rclone mount GDTeam_raye_qinse: /home/emby/GDTeam_raye_qinse --allow-other --allow-non-empty

[Install]
WantedBy=multi-user.target
```
