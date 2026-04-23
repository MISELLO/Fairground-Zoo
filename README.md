# Fairground-Zoo
A specialized toolset designed to digitize, catalog, and display a collection of "animal tickets" from traditional fairground attractions (Feria del Ram, Mallorca, Spain)

What started as a child's hobby of collecting discarded tickets from a fair game called *Tombolay* turned into a set of scripts to digitize these items.

## Features
It uses bash scripts to handle all functions:
- **Image processing**:  The image is renamed according to a randomly-generated ID and moved to a raw/ folder. Two images are generated from this file: the original and a thumbnail.
- **Database administration**: The database is created automatically. You can also list its content and delete an image (the database entry and all associated photos will be removed).
- **Backups**: You can create a backup of the database (not the images).
- **Web generation**: It generates a simple static website with all the images.

## Requirements
In order to work properly you need:
- The [Go](https://golang.org/) programming language
- The [GraphicsMagick](http://www.graphicsmagick.org/) Image Processing System
- And the [SQLite3](https://sqlite.org/) database.

## Installation
Clone the repository
```
git clone https://github.com/MISELLO/Fairground-Zoo/
```
Make sure all requirements listed above are installed.
## Usage
To start, just scan the animal tickets with the software of your preference and use the *newAnimal.sh* script.
```
./newAnimal.sh image.png cangrejo
```
Once the process completes, your image is ready.
You can use the other scripts in order to list the database content, delete an image, create a backup, or generate the website.
