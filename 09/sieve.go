package main

import "fmt"

func generate(c chan int) {
	for i := 2; ; i++ {
		c <- i
	}
}

func filter(p int, in, out chan int) {
	for {
		x := <-in
		if x%p != 0 {
			out <- x
		}
	}
}

func main() {
	in := make(chan int)
	go generate(in)

	for i := 0; i < 100; i++ {
		p := <-in
		fmt.Println(p)
		out := make(chan int)
		go filter(p, in, out)
		in = out
	}
}
