package main

import (
	"database/sql"
	"fmt"
	"os"

	_ "github.com/mattn/go-sqlite3"
)

var dbName string = "./animal_tombola.db"

func main() {
	db, err := sql.Open("sqlite3", dbName)
	if err != nil {
		fmt.Println("KO")
		os.Exit(1)
	}
	defer db.Close()

	sqlCreate := `
CREATE TABLE IF NOT EXISTS animals (
	id TEXT PRIMARY KEY CHECK(length(id) = 5),
	name TEXT NOT NULL
);`

	_, err = db.Exec(sqlCreate)
	if err != nil {
		fmt.Println("KO")
		os.Exit(2)
	}

	fmt.Println("OK")
}
