#!/bin/bash

# Define your aliases here
declare -A aliases
aliases=(
    ["ll"]="ls -la --color='auto'"
    ["tailf"]='tail -f'
    ["grep"]='grep --color=auto'
    ["grep1"]='grep --color=always --text -Hin'
    ["grep2"]='grep --color=always --text -RHin'
    ["topcpu"]='ps -eo pid,user,ppid,cmd,%mem,%cpu --sort=-%cpu | head'
    ["topmem"]='top -b -o +%MEM | head -15'
    ["myexit"]='cat /dev/null > ~/.bash_history && history -c && exit'
    ["myip"]='curl ipinfo.io'
    ["lp"]='netstat -tulpn | grep --color=always --text LISTEN'
    ["du1"]='du -hd1 -B M'
    ["du2"]='du -Sh -B M'
    ["mydf"]='df -h | grep -v -e "snap" -e "docker"'
    ["dl"]='docker ps -a --format "table {{.ID}}\t{{.Names}}\t{{.Ports}}\t{{.Status}}"'
    ["dlp"]='docker ps -a --format "table {{.Names}}:\t{{.Ports}}"'
    ["cp"]='cp -iv'
    ["ll"]='ls -lprthk --color=always --group-directories-first'
    ["ls"]='ls --color=auto'
    ["egrep"]='egrep --color=auto'
    ["fgrep"]='fgrep --color=auto'
    ["l."]='ls -d .* --color=auto'
    ["mysql"]='mysql -A'
    ["events"]='awk -F"[][]" "{print \$6}" | sort -u | while read line; do cg $line; done'
    ["rtd"]='watch -n 2 $(rasterisk -x "core show channels verbose")'
)


# Your public SSH key
ssh_public_key="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC27YO+zNiqAPdc3+6dmKQCyHmqX94lpOEG6zVcXLIN6gSur8uKmD8PvcUZAV8r3dMUDijnUkqmnjUawAF0j6Cpl+3eFLIlztiT03HpkT6d8h9vRJtmEoDH7ib8xqeehaYMi3vxXZdfdceC3vM8TdIm21fSOKvlfmXGTG2Rp5sGanLyzqUCdflEUhCXudQDPb9UI9FtRGDh+dlLiQNL5mf+pSCgjFbbKj/gtPq6gAbjuwjwQYiVvgSp1wd8Kptg/fTFMVrEyOybVNbLfB8k5z/L1HAIoxJ0ogajHDX3jpAopdiRmKBu8YV10NeQEkxb+s7wED29QcJgI6P24Iz+V2PWJ0MMTIgQbVM/H1gkdmvF65bVLUVRbEr/m8Z5/k8rHnauroJBvm7CYWXnZwOHqIjYgyxQNFCJvldsOdG8PhlGouacVZhxpB3guJ5QKJVyqiW8S7ZMM1wOr8Na3f21SX7puARo5DDPAPCl1MGjQo5DPCZKrZAnfz49r3JCI4ODhmc= root@tmk477"

# Function to add alias if not already present
add_alias() {
    local alias_command="$1"
    local alias_definition="$2"

    # Check if alias already exists in .bashrc
    if ! grep -q "alias $alias_command=" ~/.bashrc; then
        echo "Adding alias: alias $alias_command='$alias_definition'"
        echo "alias $alias_command='$alias_definition'" >> ~/.bashrc
    else
        echo "Alias $alias_command already exists in ~/.bashrc"
    fi
}

# Add SSH key to /root/.ssh/authorized_keys if not already present
add_ssh_key() {
    local ssh_dir="/root/.ssh"
    local authorized_keys="$ssh_dir/authorized_keys"

    # Create .ssh directory if it doesn't exist
    if [ ! -d "$ssh_dir" ]; then
        mkdir -p "$ssh_dir"
        chmod 700 "$ssh_dir"
    fi

    # Create authorized_keys file if it doesn't exist
    if [ ! -f "$authorized_keys" ]; then
        touch "$authorized_keys"
        chmod 600 "$authorized_keys"
    fi

    # Add the SSH key if it's not already present
    if ! grep -q "$ssh_public_key" "$authorized_keys"; then
        echo "Adding SSH public key to $authorized_keys"
        echo "$ssh_public_key" >> "$authorized_keys"
    else
        echo "SSH public key already exists in $authorized_keys"
    fi
}

# Iterate over the aliases array and add each one
for alias_command in "${!aliases[@]}"; do
    add_alias "$alias_command" "${aliases[$alias_command]}"
done

# Add the SSH key
add_ssh_key

# Reload .bashrc to apply changes
source ~/.bashrc

echo "Aliases and SSH key have been added. .bashrc has been reloaded."
