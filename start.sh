#!/bin/bash

puppet apply -d -v /root/site.pp
/sbin/rsyslogd -i /var/run/syslogd.pid -c 5 -x -n
