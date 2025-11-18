package main

import (
	"math/rand"
	"time"
)

func stage_worker(c chan int, fin1, start2 chan bool) {
	time.Sleep(time.Duration(300+rand.Intn(1500)) * time.Millisecond)

	fin1 <- true
	<-start2

	time.Sleep(time.Duration(300+rand.Intn(1500)) * time.Millisecond)
	fin1 <- true

}

func run_stages() {
	start2 := make(chan bool)
	fin1 := make(chan bool)
	c1 := make(chan int)
	c2 := make(chan int)
	go stage_worker(c1, fin1, start2)
	go stage_worker(c2, fin1, start2)

	for i := 0; i < 2; i++ {
		<-fin1 // Receives twice so it's the same amount of workers
	}

	close(start2)

	for i := 0; i < 2; i++ {
		<-fin1
	}
}
