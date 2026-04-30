package main

import (
	"database/sql"
	"fmt"
	"os"

	_ "github.com/mattn/go-sqlite3"
)

var dbName string = "./animal_tombola.db"
var title string = "Fairground Zoo"
var h1 string = "FAIRGROUND ZOO"

func main() {
	db, err := sql.Open("sqlite3", dbName)
	if err != nil {
		fmt.Fprintln(os.Stderr, "Could not open the database", dbName)
		os.Exit(1)
	}
	defer db.Close()

	fmt.Println("<html>")
	fmt.Println("	<head>")
	fmt.Println("		<meta charset=\"UTF-8\">")
	fmt.Println("		<title>" + title + "</title>")
	fmt.Println("	</head>")
	fmt.Println("	<body>")
	fmt.Println("		<h1>" + h1 + "</h1>")

	rows, err := db.Query("SELECT id, name FROM animals ORDER BY name")
	if err != nil {
		fmt.Fprintln(os.Stderr, "Could not load the rows of the database", err)
		os.Exit(1)
	}
	defer rows.Close()

	for rows.Next() {
		var id, name string

		err = rows.Scan(&id, &name)
		if err != nil {
			fmt.Fprintln(os.Stderr, "Got an error while loading a row of the database", err)
			os.Exit(1)
		}

		fmt.Printf("		<a href=\"./original/%s.png\" target=\"_blank\" title=\"%s\">", id, name)
		fmt.Printf("<img src=\"./mini/%s-mini.png\" alt=\"%s\"></a>\n", id, name)
	}

	fmt.Println("	</body>")
	fmt.Println("<html>")
}
