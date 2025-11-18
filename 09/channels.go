package main

import (
	"fmt"
	"time"
)

func write(c chan int) {
	time.Sleep(1 * time.Second)
	c <- 1
	fmt.Println("Written")
}

func run_ch() {
	var c chan int // nil channel (always blocks)

	// c <- 1           // Send to channel
	// fmt.Println(<-c) // Receive from channel

	// c = make(chan int) // Unbuffered channel (rendezvous)
	// // Sender blocks until there's a receiver
	// // Receiver blocks until there's a sender
	// go write(c)
	// time.Sleep(3 * time.Second)
	// fmt.Println(<-c)

	c = make(chan int, 3) // Buffered channel
	for i := 0; i < 3; i++ {
		c <- i
	}
	fmt.Println("finish writing")

	// for i := 0; i < 3; i++ {
	// 	fmt.Println(<-c)
	// }

	// <-c // Deadlock

	close(c)

	// Can cause deadlock too
	// Reads until the end (until channel is closed)
	for x := range c {
		fmt.Println(x)
	}

	// A closed channel can always be read
	// Always returns the zero value
	// fmt.Println(<-c)

	if x, ok := <-c; ok {
		fmt.Println(x)
	} else {
		fmt.Println("Channel closed")
	}
}
