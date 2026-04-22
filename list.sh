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

sqlite3 -batch -header -table "$DB" "SELECT id, name FROM animals ORDER BY name;"

