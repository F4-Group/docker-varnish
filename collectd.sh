#!/bin/bash

set -e

if [ -f /etc/collectd.conf ]; then
  echo "Starting Collectd"
  cat /etc/collectd.conf
  exec collectd -C /etc/collectd.conf -f
else
  echo "Collectd configuration file not found, Collectd not started"
fi
