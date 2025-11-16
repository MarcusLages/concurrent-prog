package main

import "fmt"

var x = 1

func main() {
	var a, b = 1, "hello"
	var c float64 = 3.14
	d, e := "नमस्ते", "こんにちは"  // short declaration (only inside functions)
  fmt.Println(a, b, c, d, e, x)
	d, f := "hello", 2  // OK, as f is new
	fmt.Println(d, f)
	var y int  // zero value
	fmt.Println(y)

	arrays()
	slices()
	maps()
	funcs()
}

func arrays() {
	fmt.Println("ARRAYS")
	var a [5]int
  fmt.Println(a)  // uninitialized; zero value
	b := [5]int{1, 2, 3, 4, 5}  // arrays are values
	fmt.Println(b)
	a = b
	fmt.Println(a, b)
	fmt.Println(sum_array5(a))
	fmt.Println(sum_array5_v2(&a))
  c := [...]int{1, 2, 3}  // ask compiler to count	
	fmt.Println(c)

	if v, ok := find(b[:], func(x int) bool { return x % 5 == 0}); ok {
		fmt.Println(v)
	}
}

func sum_array5(a [5]int) int {  // pass-by-value
  total := 0

	for i := 0; i < 5; i++ {  // no ++i
		total += a[i]
	}

	return total
}

func slices() {
	fmt.Println("SLICES")
	var s1 []int    // nil slice
	var s2 = []int{}  // empty slice
	fmt.Println(s1, s2)
	// generally can't compare slices; but can compare a slice to nil
	fmt.Println(s1 == nil, s2 == nil)
	// slice: address + len + cap
	s := []int{1, 2, 3, 4}
	fmt.Println(s, len(s), cap(s))
	a := [...]int{0, 1, 2, 3, 4, 5, 6, 7}
	s = a[1:4]  // [1, 4)
	fmt.Println(s, len(s), cap(s))  // len: 3, cap: 7
	s[0] = -1  // changes a[1]
	fmt.Println(a)
	s = append(s, -4, -5)  // modifies a as well; note: can append to nil slice
	fmt.Println(s, a)
	s = append(s, -10, -11, -12) // cap exceeded; allocates new dynamic array
	fmt.Println(s, a)
	s[0] = 1000
  fmt.Println(a)
	fmt.Println(sum(a[:]))
}

func sum_array5_v2(a *[5]int) int {  // pass-by-value
	total := 0

	for _, x := range *a {  // x is a copy
		total += x
	}

/*	
	for i := 0; i < 5; i++ {
		total += a[i]
	}
*/	
	return total
}

func sum(s []int) int {
	total := 0

	for i := 0; i < len(s); i++ {
		total += s[i]
	}

	return total
}

func maps() {
	// map is a reference type
	var m map[string]int  // nil map (can't store anything)
	m = map[string]int{"hello": 1, "world": 5}
	fmt.Println(m)
	m["hi"] = 2
	fmt.Println(m["xxx"])  // zero value
	if v, ok := m["hi"]; ok {
		fmt.Println(v)
	} else {
		fmt.Println("not found")
	}
	delete(m, "hi")
  m2 := make(map[string]int)
	m2["hello"] = 5
}

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

	for i := 1; i <= 3; i++ {
		fmt.Println(c1())
	}

	for i := 1; i <= 3; i++ {
		fmt.Println(c2())
	}

  s := mk_mk_counter("student counter")
	sc := s(1)
	sc()
	sc()
	sc2 := s(10)
	sc2()

	i := mk_mk_counter("instructor counter")
	ic := i(0)
	ic()
	ic()
}

func make_counter(start int) func() int {
	return func() int {
		v := start
		start++
		return v
	}
}

// can we make a function that returns a function that returns a function?
func mk_counter(label string, start int) func() {
	return func() {
		v := start
		start++
		fmt.Println(label, v)
	}
}

func mk_mk_counter(label string) func(int) func() {
	return func(x int) func() {
		return mk_counter(label, x)
	}
}

