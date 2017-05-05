#!/bin/bash

set -e

sed -i "s/\$HOSTNAME/$HOSTNAME/" /etc/collectd.conf
sed -i "s/\$MONITORING_HOST/$MONITORING_HOST/" /etc/collectd.conf

collectd -C /etc/collectd.conf

exec bash -c \
  "exec varnishd -F \
  -a :80 \
  -T localhost:6082 \
  -S /etc/varnish/secret \
  -f $VCL_CONFIG \
  -s malloc,$CACHE_SIZE \
  $VARNISHD_PARAMS" 2>&1
