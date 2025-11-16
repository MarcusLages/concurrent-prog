package main

import "fmt"

// Abstract method f
// Also works as duck typing
type I interface {
	f() int
}

type S1 struct{}
type S2 struct{}

// Value receiver
func (s S1) f() int { return 1 }

// Reference/point receiver
// More restrictive
func (s *S2) f() int { return 2 }

func run() {
	// Both structure and structure pointer implement the interface
	var i1 I = S1{}
	var i2 I = &S1{}

	// Only the pointer implements the interface
	// var _ I = S2{}
	var i3 I = &S2{}

	// Type assertion
	// Check whether i1 is of type S1 (casting/type checking)
	// x := i1.(S1)
	// fmt.Println(x)
	var _ = i2.(*S1)
	var _ = i3.(*S2)
	if x, ok := i1.(S1); ok {
		fmt.Println(x)
	}
}
