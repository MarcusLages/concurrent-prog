package main

import (
	"fmt"
	"math"
)

type Circle struct {
   x int
	 y int
	 r int
}

func (c Circle) Draw() {  // value receiver
	fmt.Printf("(%d, %d), %d\n", c.x, c.y, c.r)
}

func (c *Circle) Scale(factor int) {  // pointer receiver
  c.r *= factor
}

func (c Circle) Area() float64 {
	return float64(c.r * c.r) * math.Pi
}

func main() {
	c := Circle {
		x: 0,
		y: 0,
		r: 1,  // must have comma
	}
	c.Scale(2)
	c.Draw()
	circles := []*Circle{&c, &Circle{1, 2, 3}}

	total := 0.0
	for _, c := range circles {
		total += c.Area()
	}
	fmt.Println(total)
}

