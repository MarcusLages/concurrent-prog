package main

import (
	"fmt"
	"math"
)

type Circle struct {
	x, y, r int
	// x int
	// y int
	// r int
}

func (c Circle) Draw() { // Value receiver
	fmt.Printf("(%d, %d), %d\n", c.x, c.y, c.r)
}

func (c *Circle) Scale(factor int) { // Pointer receiver
	c.r *= factor
}

func (c Circle) Area() float64 {
	return float64(c.r*c.r) * math.Pi
}

func main() {
	c := Circle{
		x: 0,
		y: 2,
		r: 4, // Must have comma here
	}
	c.Draw()
	c.Scale(5)
	circles := []*Circle{&c, &Circle{1, 2, 3}}

	total := 0.0
	for _, c := range circles {
		total += c.Area()
	}
	fmt.Println(total)
}
