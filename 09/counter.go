package main

import (
	"fmt"
	"time"
)

var counter int
var c chan bool // Bool channel as mutex

func inc() {
	for i := 0; i < 1_000_000; i++ {
		<-c
		counter++
		c <- true
	}

	fmt.Println("Finished")
}

func run_counter() {
	// c = make(chan bool) // No unbuffered channel as a mutex
	// A channel of length 1 can be used as a mutex
	c = make(chan bool, 1) // Must be a buffered mutex
	go inc()
	go inc()

	c <- true                     // Number of reads/writes are not correct
	<-time.After(2 * time.Second) // Timer channel
	fmt.Println(counter)

	c2 := time.Tick(1 * time.Second)
	for {
		fmt.Println(<-c2)
	}
}
