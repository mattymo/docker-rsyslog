#!/bin/bash

puppet apply -d -v /root/site.pp
/usr/bin/supervisord -n

