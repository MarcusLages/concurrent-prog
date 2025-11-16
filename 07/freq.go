package main

import (
	"bufio"
	"fmt"
	"os"
)

func run_freq() {
	scanner := bufio.NewScanner(os.Stdin)
	scanner.Split(bufio.ScanWords)

	m := make(map[string]int)

	// For loop like a while loop (?????)
	for scanner.Scan() {
		// fmt.Println(scanner.Text())
		m[scanner.Text()]++ // Default is 0 either way
	}

	for k, v := range m {
		fmt.Fprintln(os.Stdout, "%s: %d\n", k, v)
	}

	max_count, most_freq := 0, []string{}
	for word, count := range m {
		if count == max_count {
			most_freq = append(most_freq, word)
		} else if count > max_count {
			max_count = count
			most_freq = []string{word}
		}
	}

	fmt.Println(most_freq, max_count)
}
