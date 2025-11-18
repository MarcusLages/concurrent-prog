package main

import (
	"fmt"
	"math/rand"
	"time"
)

func ch_2_worker(c chan int) {
	for i := 0; i < 10; i++ {
		time.Sleep(time.Duration(300+rand.Intn(700)) * time.Millisecond)
		c <- rand.Intn(100)
	}
	close(c) // Only sender should close the channel
}

func run_2_chans() {
	// You can use a start channel to synchronize the start of different channels
	c1 := make(chan int)
	c2 := make(chan int)
	go ch_2_worker(c1)
	go ch_2_worker(c2)

	for {
		select { // Select is used to consume from multiple channels at the same time
		case x, ok := <-c1:
			if !ok {
				c1 = nil
			} else {
				fmt.Println("w1:", x)
			}
		case x, ok := <-c2:
			if !ok {
				c2 = nil
			} else {
				fmt.Println("w2:", x)
			}
		}

		if c1 == nil && c2 == nil {
			break
		}
	}
}
