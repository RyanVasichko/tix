#!/bin/bash

# Function to ensure a directory exists
ensure_directory() {
    local dir_path=$1
    if [ ! -d "$dir_path" ]; then
        mkdir -p "$dir_path"
    fi
}

# Function to ensure a file exists and has the correct permissions
ensure_file_with_permissions() {
    local file_path=$1
    local permissions=$2
    if [ ! -f "$file_path" ]; then
        touch "$file_path"
    fi
    chmod "$permissions" "$file_path"
}

# Function to ensure a directory exists and has the correct ownership
ensure_directory_with_ownership() {
    local dir_path=$1
    local user=$2
    local group=$3
    ensure_directory "$dir_path"
    chown "$user:$group" "$dir_path"
}

# Function to configure Ubuntu auto-updates and automatic reboot
configure_ubuntu_auto_updates() {
    local apt_config_file="/etc/apt/apt.conf.d/20auto-upgrades"
    local unattended_upgrades_config="/etc/apt/apt.conf.d/50unattended-upgrades"

    # Configure auto-updates if not already set
    if [ ! -f "$apt_config_file" ]; then
        echo "APT::Periodic::Update-Package-Lists \"1\";" > "$apt_config_file"
        echo "APT::Periodic::Unattended-Upgrade \"1\";" >> "$apt_config_file"
    fi

    # Configure automatic reboot at 2 AM
    if ! grep -q "Unattended-Upgrade::Automatic-Reboot-Time" "$unattended_upgrades_config"; then
        echo -e "\n// Automatically reboot at 2 AM if required\nUnattended-Upgrade::Automatic-Reboot-Time \"02:00\";" >> "$unattended_upgrades_config"
    fi
}

# Main execution

ensure_directory "/letsencrypt"
ensure_file_with_permissions "/letsencrypt/acme.json" "600"
ensure_directory_with_ownership "/var/lib/tix/log" "5000" "5000"
configure_ubuntu_auto_updates

echo "Setup completed."
