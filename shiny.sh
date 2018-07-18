#!/bin/sh

exec /sbin/setuser shiny /usr/bin/shiny-server >> /var/log/shiny-server/server.log 2>&1
