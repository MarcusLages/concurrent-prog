package main

import (
	"bufio"
	"fmt"
	"os"
)

func main() {
	scanner := bufio.NewScanner(os.Stdin)
	scanner.Split(bufio.ScanWords)

	m := make(map[string]int)

	for scanner.Scan() {
		m[scanner.Text()]++
	}

	for k, v := range m {
		fmt.Printf("%s: %d\n", k, v)
	}

	max_count, most_frequent := 0, []string{}
  for word, count := range m {
		if count == max_count {
			most_frequent = append(most_frequent, word)
		} else if count > max_count {
			max_count = count
			most_frequent = []string{word}
		}
	}

	fmt.Println(most_frequent, max_count)
}
