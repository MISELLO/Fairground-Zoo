#!/bin/bash

# Check dependencies at first
source ./utils/dependencies.sh
check_dependencies "go"

output="./index.html"

go run ./utils/generate_website.go > $output
