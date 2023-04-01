#!/bin/bash

# Copy authorized keys to root user
sudo mkdir -p /root/.ssh
sudo cp /home/ubuntu/.ssh/authorized_keys /root/.ssh/
sudo chmod 700 /root/.ssh
sudo chmod 600 /root/.ssh/authorized_keys
sudo chown -R root:root /root/.ssh