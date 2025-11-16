package main

import (
	"math/rand/v2"
	"sync"
	"time"
)

type Resource struct {
	navail int // n available
	cond   *sync.Cond
}

func NewResource(capacity int) *Resource {
	return &Resource{
		navail: capacity,
		cond:   sync.NewCond(&sync.Mutex{}),
		// Lock interface which a &Mutex satisfies
	}
}

func (r *Resource) Acquire() {
	r.cond.L.Lock()     // Mutex
	for r.navail == 0 { // No resource available
		r.cond.Wait() // Autoomatically unlocks the mutex
	}
	r.navail--
	// Use resource
	r.cond.L.Unlock()

}

func (r *Resource) Release() {
	r.cond.L.Lock()
	r.navail++
	r.cond.Signal()
	r.cond.L.Unlock()
}

func work(min, max int) {
	r := rand.IntN(max - min)
	time.Sleep(time.Duration(min+r) * time.Millisecond)
}

func worker(r *Resource) {
	for i := 0; i < 100; i++ {
		work(200, 500)
		r.Acquire()
		work(500, 1_000)
		r.Release()
	}
}

func main() {
	r := NewResource(3)
	go worker(r)
	go worker(r)
	go worker(r)
	go worker(r)

	<-make(chan int) // Channels
	// Groups still work

}
