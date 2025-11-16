package main

import (
	"fmt"
	"sync"
)

type Buffer struct {
	p, q, r            int
	mutex              sync.Mutex // Just one mutex to take care of all 3 variables
	p_less_q, q_less_r *sync.Cond // Conditionals that should be signal when p < q and q < r, respectively
}

func NewBuffer() *Buffer {
	b := new(Buffer)
	b.p_less_q = sync.NewCond(&b.mutex)
	b.q_less_r = sync.NewCond(&b.mutex)
	return b
}

func (b *Buffer) Print_r() {
	b.mutex.Lock()

	// R can always keep adding itself and printing
	b.r++
	b.q_less_r.Signal() // Signals that q < r is now for other goroutines
	fmt.Printf("\t\tR (%d)\n", b.r)
	// time.Sleep(time.Duration(100) * time.Millisecond)

	b.mutex.Unlock()
}

func (b *Buffer) Print_q() {
	b.mutex.Lock()

	// Q has to check if q < r before it's able to add/print q
	for b.q == b.r {
		b.q_less_r.Wait()
	}
	b.q++
	b.p_less_q.Signal() // Signals that p < q is now for other goroutines
	fmt.Printf("\tQ (%d)\n", b.q)
	// time.Sleep(time.Duration(100) * time.Millisecond)

	b.mutex.Unlock()
}

func (b *Buffer) Print_p() {
	b.mutex.Lock()

	// P has to check if p < q before it's able to add/print p
	for b.p == b.q {
		b.p_less_q.Wait()
	}
	b.p++
	fmt.Printf("P (%d)\n", b.p)
	// time.Sleep(time.Duration(100) * time.Millisecond)

	b.mutex.Unlock()
}

// One printer for each variable
func p_printer(b *Buffer) {
	for {
		b.Print_p()
	}
}

func q_printer(b *Buffer) {
	for {
		b.Print_q()
	}
}

func r_printer(b *Buffer) {
	for {
		b.Print_r()
	}
}

func main() {
	b := NewBuffer()
	go r_printer(b)
	go q_printer(b)
	go p_printer(b)

	<-make(chan int)
}
