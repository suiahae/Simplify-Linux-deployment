# This file shoud be put at /etc/profile.d/
# sudo cp proxy.sh -t /etc/profile.d/

export http_proxy=http://192.168.233.1:7890/
export no_proxy=localhost,127.0.0.0/8,::1
export ftp_proxy=http://192.168.233.1:7890/
export https_proxy=http://192.168.233.1:7890/

export HTTP_PROXY=http://192.168.233.1:7890/
export NO_PROXY=localhost,127.0.0.0/8,::1
export HTTPS_PROXY=http://192.168.233.1:7890/
export FTP_PROXY=http://192.168.233.1:7890/
