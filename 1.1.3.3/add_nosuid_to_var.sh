# Copyright (c) 2023 FB Pro GmbH
# All rights reserved.

#!/bin/bash

# Define the fstab file location
FSTAB_FILE="/etc/fstab"

# Check if /etc/fstab exists
if [[ ! -f "$FSTAB_FILE" ]]; then
    echo "Error: $FSTAB_FILE does not exist."
    exit 1
fi

# Make a backup of fstab before modifying
cp "$FSTAB_FILE" "${FSTAB_FILE}.bak"

# Use awk to process the file
awk -v OFS='\t' '
    # Search for lines that contain "/var" and not commented out
    $2 == "/var" && !/^#/ {
        # Split the fourth column by comma to get the options
        split($4, opts, ",")
        found = 0
        # Check if "nosuid" is among the options
        for (i in opts) {
            if (opts[i] == "nosuid") {
                found = 1
                break
            }
        }
        # If "nosuid" was not found, add it
        if (!found) {
            $4 = $4 ",nosuid"
            print "#nosuid added for /var in fstab by hardening."
        }
    }
    { print }
' "$FSTAB_FILE" > /tmp/fstab.new

# Check if changes were made and move the new file into place
if cmp -s "$FSTAB_FILE" /tmp/fstab.new; then
    echo "No changes needed for /var in fstab."
    rm /tmp/fstab.new
else
    mv /tmp/fstab.new "$FSTAB_FILE"
    echo "Updated fstab with nosuid for /var."
fi
