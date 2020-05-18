sudo zip -r ~/Documents/yun.repos.d.bak.zip /etc/yum.repos.d

sudo sh -c 'echo "[fedora]
name=Fedora \$releasever - \$basearch
failovermethod=priority
baseurl=https://mirrors.tuna.tsinghua.edu.cn/fedora/releases/\$releasever/Everything/\$basearch/os/
metadata_expire=28d
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-\$releasever-\$basearch
skip_if_unavailable=False
" > /etc/yum.repos.d/fedora.repo';

sudo sh -c 'echo "[updates]
name=Fedora \$releasever - \$basearch - Updates
failovermethod=priority
baseurl=https://mirrors.tuna.tsinghua.edu.cn/fedora/updates/\$releasever/Everything/\$basearch/
enabled=1
gpgcheck=1
metadata_expire=6h
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-\$releasever-\$basearch
skip_if_unavailable=False
" > /etc/yum.repos.d/fedora-updates.repo';

sudo sh -c 'echo "[fedora-modular]
name=Fedora Modular \$releasever - \$basearch
failovermethod=priority
baseurl=https://mirrors.tuna.tsinghua.edu.cn/fedora/releases/\$releasever/Modular/\$basearch/os/
enabled=1
metadata_expire=7d
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-\$releasever-\$basearch
skip_if_unavailable=False
" > /etc/yum.repos.d/fedora-modular.repo';

sudo sh -c 'echo "[updates-modular]
name=Fedora Modular \$releasever - \$basearch - Updates
failovermethod=priority
baseurl=https://mirrors.tuna.tsinghua.edu.cn/fedora/updates/\$releasever/Modular/\$basearch/
enabled=1
gpgcheck=1
metadata_expire=6h
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-\$releasever-\$basearch
skip_if_unavailable=False
" > /etc/yum.repos.d/fedora-updates-modular.repo';