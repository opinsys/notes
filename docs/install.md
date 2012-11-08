## Background information

Operating system: Ubuntu 12.04 (Precise Pangolin)

## Install dependencies

### Debian packages
```shell
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install build-essential git-core graphicsmagick
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


### Redis
```shell
get http://redis.googlecode.com/files/redis-2.6.2.tar.gz
tar zxf redis-2.6.2.tar.gz
cd redis-2.6.2
make
sudo make install
```

## Setting up the Redis server

### Create user
```
sudo adduser --no-create-home --disabled-password --disabled-login --system redis
```

### Add configuration file
```
sudo mkdir /etc/redis
```

/etc/redis/redis.conf
```
aemonize no
pidfile /var/run/redis.pid
port 6379
timeout 0
loglevel notice
logfile stdout
databases 16
save 30 1
stop-writes-on-bgsave-error yes
rdbcompression yes
rdbchecksum yes
dbfilename dump.rdb
dir /var/lib/redis
slave-serve-stale-data yes
slave-read-only yes
slave-priority 100
appendonly no
appendfsync everysec
no-appendfsync-on-rewrite no
auto-aof-rewrite-percentage 100
auto-aof-rewrite-min-size 64mb
lua-time-limit 5000
slowlog-log-slower-than 10000
slowlog-max-len 128
hash-max-ziplist-entries 512
hash-max-ziplist-value 64
list-max-ziplist-entries 512
list-max-ziplist-value 64
set-max-intset-entries 512
zset-max-ziplist-entries 128
zset-max-ziplist-value 64
activerehashing yes
client-output-buffer-limit normal 0 0 0
client-output-buffer-limit slave 256mb 64mb 60
client-output-buffer-limit pubsub 32mb 8mb 60
```

### Change ownership

```
sudo chown -R redis /etc/redis
```

### Create data directory

```
sudo mkdir /var/lib/redis
sudo chown redis /var/lib/redis
```

### Add upstart script for the Redis

/etc/init/redis.conf
```
description "redis"

start on runlevel [23]
stop on shutdown

exec sudo -u redis /usr/local/bin/redis-server /etc/redis/redis.conf

respawn
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
npm install
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
sudo start redis
sudo start notes
```