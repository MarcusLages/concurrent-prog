package main

import (
	"fmt"
	"math/rand"
	"time"
)

func worker(stop, c chan int) {
	for {
		select {
		case <-stop:
			fmt.Println("stopping")
			return
		case <-c:
			time.Sleep(time.Duration(300+rand.Intn(700)) * time.Millisecond)
			r := rand.Intn(200)
			if r%37 == 0 {
				c <- r
				fmt.Println("stopping")
				return
			}
		}
	}
}

func run_search() {
	stop := make(chan int)
	c := make(chan int)

	go worker(stop, c)
	go worker(stop, c)

	fmt.Println(<-c)
	close(stop)
	// <-c // Something here that I forgot, but it's in albert's code
}
