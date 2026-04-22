package main

import (
	"database/sql"
	"fmt"
	"math/rand/v2"
	"os"

	_ "github.com/mattn/go-sqlite3"
)

const charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
const dbName = "./animal_tombola.db"
const retries = 5
const length = 5

func insertAnimal(db *sql.DB, name string) (string, error) {
	for range retries {
		b := make([]byte, length)
		for i := range b {
			b[i] = charset[rand.IntN(len(charset))]
		}
		newID := string(b)
		if !idTaken(db, newID) {
			_, err := db.Exec("INSERT INTO animals (id, name) VALUES (?, ?)", newID, name)
			if err != nil {
				return "", err
			}
			return newID, nil
		}
	}
	return "", fmt.Errorf("Max retries reached")
}

func idTaken(db *sql.DB, id string) bool {
	var c int
	err := db.QueryRow("SELECT count(*) c FROM animals WHERE id = ?", id).Scan(&c)
	if err != nil || c > 0 {
		return true
	}
	return false
}

func main() {

	// Parameter check
	if len(os.Args) < 2 {
		fmt.Fprintln(os.Stderr, "Please, provide one name to add to the database")
		os.Exit(1)
	}

	// Connect to database
	db, err := sql.Open("sqlite3", dbName)
	if err != nil {
		fmt.Println("KO")
		os.Exit(1)
	}
	defer db.Close()

	// Insert the animal
	id, err := insertAnimal(db, os.Args[1])
	if err != nil {
		fmt.Println("KO")
		fmt.Println(err)
		os.Exit(2)
	}
	fmt.Println(id)
}
