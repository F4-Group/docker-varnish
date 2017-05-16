#!/bin/bash

set -e

## collectd
if [ -f /etc/collectd.conf ]; then
  echo "Starting Collectd"
  cat /etc/collectd.conf
  collectd -C /etc/collectd.conf
  echo "Collectd now running"
else
  echo "Collectd configuration file not found, Collectd not started"
fi

if [ ! -f /etc/varnish/secret ]; then
    dd if=/dev/random of=/etc/varnish/secret count=1
fi

exec varnishd -F \
  -a :80 \
  -T localhost:6082 \
  -S /etc/varnish/secret \
  -f $VCL_CONFIG \
  -s malloc,$CACHE_SIZE \
  $VARNISHD_PARAMS
