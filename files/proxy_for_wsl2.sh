# This file shoud be put at /etc/profile.d/
# sudo cp proxy_for_wsl2.sh -t /etc/profile.d/

export http_proxy=http://$(ip route | grep default | awk '{print $3}'):7890/
export no_proxy=localhost,127.0.0.0/8,::1
export ftp_proxy=http://$(ip route | grep default | awk '{print $3}'):7890/
export https_proxy=http://$(ip route | grep default | awk '{print $3}'):7890/

export HTTP_PROXY=http://$(ip route | grep default | awk '{print $3}'):7890/
export NO_PROXY=localhost,127.0.0.0/8,::1
export HTTPS_PROXY=http://$(ip route | grep default | awk '{print $3}'):7890/
export FTP_PROXY=http://$(ip route | grep default | awk '{print $3}'):7890/
