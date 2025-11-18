package main

import (
	"fmt"
	"math/rand"
	"time"
)

func ch_2_worker_v2(c chan int) {
	for {
		time.Sleep(time.Duration(300+rand.Intn(700)) * time.Millisecond)
		c <- rand.Intn(100)
	}
}

func run_2_chans_v2() {
	c1 := make(chan int)
	c2 := make(chan int)
	go ch_2_worker_v2(c1)
	go ch_2_worker_v2(c2)

	for {
		select { // Select is used to consume from multiple channels at the same time
		case x := <-c1:
			fmt.Println("w1:", x)
		case x := <-c2:
			fmt.Println("w2:", x)
		}
	}
}
