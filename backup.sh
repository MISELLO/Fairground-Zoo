#!/bin/bash

# Check dependencies at first
source ./utils/dependencies.sh
check_dependencies "sqlite3"

# Database file
DB="./animal_tombola.db"

# Make sure the database exists
if [ ! -f "$DB" ]; then
    echo -e "\e[41mERROR\e[0m: database does not exist."
    exit 1
fi

# Date suffix
SUF=$(date +"%Y%m%d_%H%M%S")

# Backup path
DST="${DB}.BK_${SUF}"

# Backup per se
sqlite3 "$DB" ".backup '$DST'"

# Check exit status
if [ $? -eq 0 ]; then
    echo "Backup done properly on: $DST"
else
    echo -e "\e[41mERROR\e[0m: backup could not be created."
    exit 1
fi
