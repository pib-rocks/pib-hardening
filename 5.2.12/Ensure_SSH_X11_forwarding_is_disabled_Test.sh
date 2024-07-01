#!/bin/bash

# File path
SSHD_CONFIG="/etc/ssh/sshd_config"

# Function to check for the X11Forwarding setting in the configuration file
check_x11forwarding_config() {
    if grep -qiE "^\s*X11Forwarding\s+no\s*$" "$SSHD_CONFIG"; then
        echo "The line 'X11Forwarding no' (case insensitive, whitespace tolerant) exists in $SSHD_CONFIG"
        return 0
    else
        echo "The line 'X11Forwarding no' (case insensitive, whitespace tolerant) does not exist in $SSHD_CONFIG"
        return 1
    fi
}

# Function to check the effective sshd configuration
check_effective_x11forwarding() {
    local hostname=$(hostname)
    local ip_address=$(grep "$hostname" /etc/hosts | awk '{print $1}')

    if sshd -T -C user=root -C host="$hostname" -C addr="$ip_address" | grep -qi "x11forwarding yes"; then
        echo "sshd -T command indicates 'X11Forwarding yes' which is not allowed."
        return 1
    else
        echo "sshd -T command does not indicate 'X11Forwarding yes'."
        return 0
    fi
}

# Main execution
# Check sshd configuration file
check_x11forwarding_config
config_result=$?

# Check effective sshd configuration
check_effective_x11forwarding
effective_result=$?

# Determine the final result
if [[ $config_result -eq 0 ]] && [[ $effective_result -eq 0 ]]; then
    exit 0
else
    exit 1
fi
