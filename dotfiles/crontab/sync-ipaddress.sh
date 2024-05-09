#!/bin/bash

# Telegram bot token
TOKEN="6260054792:AAET_Jc-RQY1W-wPteh0AyYzrK7ZfNMykKU"

# Telegram chat ID
CHAT_ID="880666374" # personal chat ID

# File to store the last sent IP
IP_FILE="/home/hydra/last_ip.txt"

# Function to send message to Telegram
send_message() {
    local message="$1"
    curl -s -X POST "https://api.telegram.org/bot$TOKEN/sendMessage" -d "chat_id=$CHAT_ID&text=$message" > /dev/null
}

# Get current public IPv4 address
current_ip=$(curl -s https://api.ipify.org)

# Get username
username=$(whoami)

# Get computer name
computer_name=$(hostname)

# Check if IP has changed
if [[ -f $IP_FILE ]]; then
    last_ip=$(cat $IP_FILE)
else
    last_ip=""
fi

if [[ "$current_ip" != "$last_ip" ]]; then
    # Send the new IP address along with username and computer name to Telegram
    send_message "New public IP address: $current_ip%0AUsername: $username%0AComputer: $computer_name"
    
    # Save the new IP address to file
    echo "$current_ip" > $IP_FILE
fi
