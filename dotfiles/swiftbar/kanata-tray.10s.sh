#!/bin/bash

# <xbar.title>Kanata Config Manager</xbar.title>
# <xbar.version>v1.0</xbar.version>
# <xbar.author>S5K</xbar.author>
# <xbar.author.github>s5k</xbar.author.github>
# <xbar.desc>This xbar plugin allows you to manage Kanata configurations.</xbar.desc>
# <xbar.image></xbar.image>
# <xbar.dependencies>kanata, bash</xbar.dependencies>

# Paths to your configuration files
CONFIG1="$HOME/Documents/nixdots/dotfiles/kanata/config-macos-inline.kbd"
CONFIG2="$HOME/Documents/nixdots/dotfiles/kanata/config-macos.kbd"

# Function to check if Kanata is running with a specific config
is_kanata_running() {
    pgrep -f "kanata --cfg $1" > /dev/null
}

# Function to kill any running Kanata process
kill_kanata() {
    pkill -f "kanata"
}

# Function to start Kanata with a given config
start_kanata() {
    sudo kanata --cfg "$1" > /dev/null 2>&1 &
}

# Determine the current running config
if is_kanata_running "$CONFIG1"; then
    CURRENT=":keyboard.chevron.compact.down:"
elif is_kanata_running "$CONFIG2"; then
    CURRENT=":keyboard.chevron.compact.down:"
else
    CURRENT=":keyboard:"
fi

# Menu output
echo "$CURRENT"
echo "---"

# Option to switch to Config 1
if is_kanata_running "$CONFIG1"; then
    echo "Inline Keyboard (Running)"
else
    echo "Switch to Inline Keyboard | bash='$0' param1=switch param2=config1 refresh=true terminal=false"
fi

# Option to switch to Config 2
if is_kanata_running "$CONFIG2"; then
    echo "External Keyboard (Running)"
else
    echo "Switch to External Keyboard | bash='$0' param1=switch param2=config2 refresh=true terminal=false"
fi

# Option to stop Kanata
if pgrep -f "kanata" > /dev/null; then
    echo "Stop Kanata | bash='$0' param1=stop refresh=true terminal=false"
fi

# Handle the stop and switch commands
if [ "$1" == "stop" ]; then
    kill_kanata
elif [ "$1" == "switch" ]; then
    kill_kanata
    if [ "$2" == "config1" ]; then
        start_kanata "$CONFIG1"
    elif [ "$2" == "config2" ]; then
        start_kanata "$CONFIG2"
    fi
fi
