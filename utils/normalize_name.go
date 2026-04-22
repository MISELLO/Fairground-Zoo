package main

import (
	"fmt"
	"os"
)

func main() {
	if len(os.Args) < 2 {
		fmt.Fprintln(os.Stderr, "Please, provide one string to analize")
		os.Exit(1)
	}

	result := ""

	m := map[rune]byte{'0': '0', '1': '1', '2': '2', '3': '3', '4': '4', '5': '5',
		'6': '6', '7': '7', '8': '8', '9': '9', 'á': 'Á', 'Á': 'Á', 'é': 'É',
		'É': 'É', 'í': 'Í', 'Í': 'Í', 'ó': 'Ó', 'Ó': 'Ó', 'ú': 'Ú', 'Ú': 'Ú',
		'ü': 'Ü', 'Ü': 'Ü', 'ñ': 'Ñ', 'Ñ': 'Ñ'}

	for i := 1; i < len(os.Args); i++ {
		for j, c := range os.Args[i] {
			if j == 0 && result != "" {
				result += "_"
			}
			if c >= 'A' && c <= 'Z' {
				result += string(c)
			}
			if c >= 'a' && c <= 'z' {
				result += string(c - 32)
			}
			v, ok := m[c]
			if ok {
				result += string(v)
			}
		}
	}

	fmt.Println(result)
}
