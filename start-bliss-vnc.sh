#!/bin/bash

set -e

# set the passwords for the user and the x11vnc session
# based on environment variables (if present), otherwise roll with
# the defaults from the Dockerfile build.
#
if [ ! -z $blissPASS ]
then
  echo "bliss:$blissPASS" | chpasswd
fi

if [ ! -z $VNCPASS ]
then
  echo "bliss:$blissPASS" | chpasswd
fi

# Setup KVM permissions if available
if [ -e /dev/kvm ]; then
  chown bliss:bliss /dev/kvm 2>/dev/null || true
fi

# Start noVNC proxy for web access (will connect to QEMU's VNC)
cd /noVNC
websockify --web=/noVNC $LISTENPORT localhost:5901 &

# Start web server for index.html
cd /home/bliss
python3 web_server.py &

# Boot Android (QEMU will provide VNC on port 5901)
cd /home/bliss
/home/bliss/boot-bliss.sh &

# Keep container running
while true; do
    sleep 1
done
