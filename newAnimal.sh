#!/bin/bash

# Check dependencies at first
source ./utils/dependencies.sh
check_dependencies "go" "sqlite3" "gm" "convert" "identify"

# Database file
DB="./animal_tombola.db"

# Check if two or more parameters are provided
if [ $# -lt 2 ]; then
    echo -e "\e[41mERROR\e[0m: 2 or more parameters are expected"
    echo "Usage: $0 <file_name> <animal_name>"
    echo "Example: $0 image.png CANGREJO"
    exit 1
fi

# Get the parameters
file="$1"
name=`go run ./utils/normalize_name.go ${@:2}`

# Check if the source file exists
if [ ! -f "$file" ]; then
    echo -e "\e[41mERROR\e[0m ${file} not found"
    exit 1
fi

echo "Will work on $file called $name."

# Make sure the database exists
if [ ! -f "$DB" ]; then
    echo "Creating the database"
    msg=`go run ./utils/create_database.go`
    if [[ "$msg" == "OK" ]]; then
    	echo "Database created succefully"
    else
        echo "There was an error creating the database"
    fi
fi

# Checks if we already have this animal
answ=$(sqlite3 -batch "$DB" "SELECT COUNT(1) FROM animals WHERE name = '$name';")

if [ "$answ" -gt 0 ]; then
    echo "The animal $name is already on the database."
    read -p "Do you wish to add it again [Y/N]? " answ
    if [[ "$answ" != [Yy]* ]]; then
        echo "Not adding this animal"
        exit 0
    fi
fi

# Insert the animal into the database
id=`go run ./utils/insert_animal.go $name`

if [[ "$id" == "KO" || "$id" == "" ]]; then
    echo -e "\e[41mERROR\e[0m at inserting into the database"
    exit 1
fi

echo "Inserted $name with the id $id into the database."

# Create directories if they don't exist
mkdir -p original mini raw

# Building image file names
original_file="./original/${id}.png"
mini_file="./mini/${id}-mini.png"

# Create original (cropped) and mini (thumbnail) images
convert "$1" -crop '1100x1600' -gravity center "$original_file" 2>/dev/null
convert "$original_file" -thumbnail '110x160' "$mini_file" 2>/dev/null

# Check the well status and format of the generated images
size_img_1=$(identify -format "%wx%h" $original_file)
size_img_2=$(identify -format "%wx%h" $mini_file)

if [[ "$size_img_1" != "1100x1600" || "$size_img_2" != "110x160" ]]; then
    echo -e "\e[41mERROR\e[0m transforming the images!"
    echo "Resolutions were $size_img_1 (correct: 1100x1600) and $size_img_2 (correct: 110x160)."
    echo "Repeat the scaning and try again."
    rm -f "$original_file" 2>/dev/null
    rm -f "$mini_file" 2>/dev/null
    rm -f "$1" 2>/dev/null
    sqlite3 -batch "$DB" "DELETE FROM animals WHERE id = '$id';"
    echo "All $name images and database entry have been removed!"
    exit 1
fi

# We move the well done image to the raw folder in case we need it again
mv $1 ./raw/$id.png

