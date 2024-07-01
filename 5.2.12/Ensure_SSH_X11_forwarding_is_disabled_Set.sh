#!/bin/bash

# File path
SSHD_CONFIG="/etc/ssh/sshd_config"

# Function to restart SSHD
restart_sshd() {
    #if systemctl is-active --quiet sshd; then
    #    systemctl restart sshd
    #else
    #    systemctl start sshd
    #fi
echo SSHD Service MUST BE RTESTARTED
}

# Check if X11Forwarding is set to "no"
if grep -qE "^X11Forwarding no$" "$SSHD_CONFIG"; then
    echo "X11Forwarding is already set to no."
else
    # Check if X11Forwarding has any value
    if grep -qE "^X11Forwarding" "$SSHD_CONFIG"; then
        # Comment out the existing line
        sed -i '/^X11Forwarding/s/^/#/' "$SSHD_CONFIG"
    fi
    # Add or uncomment the X11Forwarding no
    echo "X11Forwarding no" >> "$SSHD_CONFIG"
    echo "X11Forwarding set to no. Restarting sshd."
    restart_sshd
fi
