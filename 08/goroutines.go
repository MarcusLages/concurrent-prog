package main

import (
	"fmt"
	"sync"
)

type Counter struct {
	value int
	mutex sync.Mutex
}

func NewCounter(start int) *Counter {
	c := new(Counter) // New returns a pointer
	c.value = start
	c.mutex = sync.Mutex{}
	return c
}

// Alt version
// func NewCounter(start int) *Counter {
// 	return &Counter{
// 		// No need to initialize mutex
// 		value: start
// 	}
// }

func (c *Counter) Inc() {
	c.mutex.Lock()
	c.value++
	c.mutex.Unlock()
}

var counter int
var mutex sync.Mutex // Mutex to avoid race conditions
// Initialized as 0 because of go
// (0 = unlocked, 1 = locked)

func inc() {
	for i := 0; i < 100_000; i++ {
		mutex.Lock()
		counter++
		mutex.Unlock()
	}
}

func inc2(c *Counter) {
	for i := 0; i < 100_000; i++ {
		c.Inc()
	}
}

func inc3(c *Counter, wg *sync.WaitGroup) {
	defer wg.Done() // Defers the execution of the function (wg.Done())
	// until before the function returns
	for i := 0; i < 100_000; i++ {
		c.Inc()
	}
}

func startGoRoutines() {
	// goroutines: similar to processes in elixir
	// When main dies, all the goroutines
	// Start goroutines
	// go inc() // Race condition
	// go inc()

	c := NewCounter(0)
	var wg sync.WaitGroup // Like a semaphore
	wg.Add(2)             // How many are we waiting for?
	go inc2(c)
	go inc2(c)
	go inc3(c, &wg)
	go inc3(c, &wg)

	// Don't want to manually wait
	// Use wait group
	// time.Sleep(2 * time.Second)
	wg.Wait()
	fmt.Println(counter)
}
