#!/bin/bash

printf "Starting up"

printf "Setting ethernet ip to 192.168.0.1"
ifconfig eth0 192.168.0.1 netmask 255.255.255.0 up

printf "\n ** Following journalctl logs: **\n\n"
journalctl -f