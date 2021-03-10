#!/bin/bash

# work mode: malloc or file
#export CMD_S_FLAG=malloc,2G
export S_FLAG=file,/var/varnish/varnish.bin,40G
# default ttl(also can config default.vcl)
export TTL=3000
# http server port
export PORT=7009
# manage port
export MPORT=7010
# varnish version
export version=6.0.6

workdir=$(pwd)
running=$(docker ps | grep varnish | wc -l)
if [[ $running -eq 0 ]];then
  running=$(docker ps -a | grep varnish | wc -l)
  if [[ $running -eq 1 ]];then
    sh ./stop.sh
  fi
  docker run --name varnish -e CMD_S_FLAG=$S_FLAG -e CMD_TTL=$TTL --restart always --entrypoint /usr/local/bin/docker-varnish-entrypoint -v $workdir/internal/varnish.bin:/var/varnish/varnish.bin -v $workdir/internal/docker-varnish-entrypoint:/usr/local/bin/docker-varnish-entrypoint -v $workdir/conf:/etc/varnish --tmpfs /var/lib/varnish:exec  -d -p $PORT:80 -p $MPORT:81  varnish:$version
fi
echo "service is running."