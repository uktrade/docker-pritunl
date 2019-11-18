#!/usr/bin/env bash

while true; do
 if [ $(/update.py) != '0' ]; then
   /restart.rb
 fi
 sleep 30
done
