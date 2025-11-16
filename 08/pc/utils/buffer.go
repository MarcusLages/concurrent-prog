package utils // Agree with folder name

import "sync"

type Buffer struct {
	capacity, nused   int
	mutex             sync.Mutex
	notFull, notEmpty *sync.Cond
}

func NewBuffer(capacity int) *Buffer {
	b := new(Buffer)
	b.capacity = capacity
	b.mutex = sync.Mutex{} // Not really necessary
	b.notFull = sync.NewCond(&b.mutex)
	b.notEmpty = sync.NewCond(&b.mutex)
	return b
}

func (b *Buffer) Put() {
	b.mutex.Lock()
	for b.nused == b.capacity { // While loop actually
		b.notFull.Wait()
	}
	b.nused++
	b.notEmpty.Signal()
	b.mutex.Unlock()
}

func (b *Buffer) Get() {
	b.mutex.Lock()
	for b.nused == 0 {
		b.notEmpty.Wait()
	}
	b.nused--
	b.notFull.Signal()
	b.mutex.Unlock()
}
