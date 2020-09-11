`sudo systemctl daemon-reload`

### ~~1.clash~~

See on https://github.com/suiahae/clash-premium-installer

~~`sudo vim /etc/systemd/system/start-docker-compose-clash.service`~~

```
[Unit]
Description=Start clash auto
After=docker.service

[Service]
Type=simple
User=minux
ExecStart=/usr/bin/docker-compose -f /home/minux/Programs/Clash/docker-compose.yaml up -d

[Install]
WantedBy=multi-user.target
```

### 2.yacd

`sudo vim /usr/lib/systemd/system/yacd-poweredby-docker_compose.service`

```
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

### 3.rclone

#### 3.1 movies

`sudo vim /usr/lib/systemd/system/rclone-movies.service`

GDTeam_raye_movies

```
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

#### 3.2 qinse

`sudo vim /usr/lib/systemd/system/rclone-qinse.service`

GDTeam_raye_qinse

```
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

#### 3.3 sundries

`sudo vim /usr/lib/systemd/system/rclone-sundries.service`

```
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

### 4.aria2c

`sudo vim /usr/lib/systemd/system/aria2.service`

```
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