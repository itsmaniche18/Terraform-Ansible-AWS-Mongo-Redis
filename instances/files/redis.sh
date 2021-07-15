#!/bin/bash
sudo apt-get update -y
sudo apt install redis-server -y
systemctl enable redis 
systemctl start redis
