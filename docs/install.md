## Background information

Operating system: Ubuntu 12.04 (Precise Pangolin)

## Install dependencies

### Debian packages
```shell
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install build-essential git-core graphicsmagick libssl-dev libreadline-dev
```

### Node
```shell
wget http://nodejs.org/dist/v0.8.14/node-v0.8.14.tar.gz
tar vzxf node-v0.8.14.tar.gz
cd node-v0.8.14/
./configure
make
sudo make install
```

### MongoDB

```shell
sudo su -
apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10
echo "deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen" > /etc/apt/sources.list.d/10gen.list
sudo apt-get update
sudo apt-get install mongodb-10gen
```


## Install and configure Notes application

### Create user
```
sudo adduser --no-create-home --disabled-password --disabled-login --system notes
```

### Get the sources

```
sudo mkdir /var/app
cd /var/app
git clone https://github.com/opinsys/notes.git
sudo chmod -R o+r /var/app/notes
sudo chmod o+w /var/app/notes/upload
```

### Install dependencies

```
cd /var/app/notes
make
```

### Create upstart script for the Notes application

/etc/init/notes.conf
```
description "notes"

start on runlevel [23]
stop on shutdown

chdir /var/app/notes
env NODE_ENV=production   

exec sudo -E -u app npm start

respawn
```

## Finally start services

```
sudo start notes
```
