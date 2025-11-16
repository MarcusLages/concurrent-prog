package main

import "fmt"

var x = 1

// y := 2 // Error

func run_vars() {
	var a, b = 1, "hello"
	var c float64 = 3.14
	// Short declaration only inside functions
	d := "asdfadf"
	d, e := "asdfadf", "idgag"
	d, f := "hello", 34
	fmt.Println(a, b, c, d, e, f)

	arrays()
	slices()
	maps()
	funcs()
}

func arrays() {
	fmt.Println("ARRAYS")
	// Anything that is uninitialized assumes the 0 value
	var a [5]int
	fmt.Println(a)
	b := [5]int{1, 2, 3, 4, 5} // Arrays are values, not pointers
	fmt.Println(b)

	// You can compare and assign arrays of the same type
	// The type of the array considers type and quantity of elements
	a = b
	fmt.Println(a, b)
	fmt.Println(sum_array5(a))
}

func sum_array5(a [5]int) int { // Pass-by-value
	total := 0
	for i := 0; i < 5; i++ { // no ++i
		total += a[i]
	}
	return total
}

func sum_array5_v2(a *[5]int) int {
	total := 0
	// Like enumerate
	// x is a copy, not a pointer to the object
	for _, x := range *a {
		total += x
	}

	total = 0
	// Like enumerate
	// x is a copy, not a pointer to the object
	for x := 0; x < 5; x++ {
		total += a[x]
		// total += (*a)[x]
	}

	return total
}

func slices() {
	fmt.Println("SLICES")
	var s1 []int     // nil slice
	var s2 = []int{} // empty slice
	fmt.Println(s1, s2)

	// Cannot compare slices
	// Can only compare slice to nil
	fmt.Println(s1, s2)

	// Slice: address pointer + length + capacity
	// Similar to   array,
	s := []int{1, 2, 3, 4}
	c := [...]int{1, 2, 3, 4}
	fmt.Println(s, c)

	// Usually create a slice out of an array
	a := [5]int{1, 2, 3, 4, 5}
	s3 := a[1:4] // [1, 4), or as index: [0, 3)
	s[0] = -1
	fmt.Println(a, s3)

	// append returns a slice
	// a is also changed
	s = append(s, -4, -5)
	fmt.Println(s, a)

	// Since now s now has a bigger size than a, it allocates a new moofu
	s = append(s, -4, -5, 4, 5)
	fmt.Println(s, a)

	fmt.Println(sum_slice(a[1:3]))
	if v, ok := find(a[:], func(x int) bool { return x%5 == 0 }); ok {
		fmt.Println(v)
	}
}

func sum_slice(s []int) int {
	total := 0
	for i := 0; i < len(s); i++ {
		total += s[i]
	}
	return total
}

func maps() {
	fmt.Println("MAPS")
	// Map is a reference type
	var m map[string]int // nil map: it cannot store anything
	m = map[string]int{"hello": 1, "world": 5}
	fmt.Println(m)
	m["hi"] = 2
	fmt.Println(m["sdfasdfasdfads"]) // It will print 0 as default value
	// Extended if statement with test
	if v, ok := m["hi"]; ok {
		fmt.Println(v)
	} else {
		fmt.Println("Not found")
	}
	delete(m, "hi")
	m2 := make(map[string]int)
	m2["hello"] = 5
}

// No option type, but you can return 2 things
func find(s []int, f func(int) bool) (int, bool) {
	for _, x := range s {
		if f(x) {
			return x, true
		}
	}
	return 0, false
}

func funcs() {
	fmt.Println("FUNCS")
	c1 := make_counter(0)
	c2 := make_counter(10)

	for i := 1; i < 3; i++ {
		fmt.Println(c1())
	}

	for i := 1; i < 3; i++ {
		fmt.Println(c2())
	}
}

// Closure of a variable
func make_counter(start int) func() int {
	return func() int {
		v := start
		start++
		return v
	}
}
