#!/bin/bash

# Check dependencies at first
source ./utils/dependencies.sh
check_dependencies "sqlite3"

# Database file
DB="./animal_tombola.db"

# Check if one id is provided
if [ $# -ne 1 ]; then
    echo -e "\e[41mERROR\e[0m: exactly one ID is expected"
    echo "Usage: $0 <animal_id>"
    echo "Example: $0 lYtGk"
    exit 1
fi

# Check if the animal ID has the correct length (is valid)
if [[ "${#1}" -ne 5 ]]; then
    echo -e "\e[41mERROR\e[0m: The animal ID is not valid:"
    echo " It has ${#1} characters instead of 5."
    exit 1
fi

# Make sure the database exists
if [ ! -f "$DB" ]; then
    echo -e "\e[41mERROR\e[0m: database does not exist."
    exit 1
fi

rm -f "./raw/$1.png" 2>/dev/null
rm -f "./original/$1.png" 2>/dev/null
rm -f "./mini/$1-mini.png" 2>/dev/null
sqlite3 -batch "$DB" "DELETE FROM animals WHERE id = '$1';"
echo "$1 images and database entry have been removed!"

