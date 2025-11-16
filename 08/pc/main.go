package main

import (
	"fmt"
	"prodcons/pc/utils"
)

func consumer(b *utils.Buffer) {
	for {
		b.Get()
		fmt.Println("-")
	}
}

func producer(b *utils.Buffer) {
	for {
		b.Put()
		fmt.Println("+")
	}
}

func main() {
	b := utils.NewBuffer(100)
	go consumer(b)
	go consumer(b)
	go consumer(b)
	go producer(b)
	go producer(b)

	<-make(chan int)
}
