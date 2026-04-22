#!/bin/bash

# Function to check dependencies
# Import it with 'source ./utils/dependencies.sh'
# And use it like: 'check_dependencies "gm" "curl" "go"'
check_dependencies() {
    local dependencies=("$@")
    
    for cmd in "${dependencies[@]}"; do
        if ! command -v "$cmd" &> /dev/null; then
            echo -e "\e[41mERROR\e[0m: The required command '$cmd' was not found."
            exit 1
        fi
    done
}
