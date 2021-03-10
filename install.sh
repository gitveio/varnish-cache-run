#!/bin/bash

cur=$(pwd)
chmod +x $cur/start.sh
chmod +x $cur/internal/docker-varnish-entrypoint
e=$(cat /etc/rc.d/rc.local | grep varnish | wc -l)
if [[ $e -eq 0 ]];then
  echo "sh $cur/start.sh" >> /etc/rc.d/rc.local
  chmod +x /etc/rc.d/rc.local
fi