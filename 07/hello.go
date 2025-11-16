// go run hello.go
// go build hello.go

// Running starts from the main package -> main()
package main

import (
	"fmt"
	"os"
)

func greet(lang string) {
	switch lang {
	case "en":
		fmt.Println("hello")
	case "fr":
		fmt.Println("bonjour")
	default:
		fmt.Println("asdf")
	}
}

// Everything that is private should start in lowercase
// Everything that is public should start in uppercase
func run() {
	// fmt.Println("hello")

	if len(os.Args) == 1 {
		greet("en")
	} else {
		greet(os.Args[1])
	}
}
