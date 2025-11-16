package main

import (
	"fmt"
	"sort"
	"strconv"
)

func primes(m, n int) []int {
	if n < 2 {
		return []int{}
	}

	// [0 to n-2] => [2, n]
	sieve := make([]bool, n-1)
	for i := range sieve {
		sieve[i] = true
	}

	// i = [0 to n -2]
	for i := range sieve {
		if !sieve[i] {
			continue
		}

		num := i + 2
		for j := num * num; j <= n; j += num {
			sieve[j-2] = false
		}
	}

	res := []int{}
	if m < 2 {
		m = 2
	}
	for i := (m - 2); i < len(sieve); i++ {
		if sieve[i] {
			res = append(res, (i + 2))
		}
	}
	return res
}

func longest_seq(l []int) int {
	cur_seq := 1
	cur_num := -1
	best_seq := 1
	for i := range l {
		x := l[i]
		if x == cur_num {
			cur_seq++
			if cur_seq > best_seq {
				best_seq = cur_seq
			}
		} else {
			cur_seq = 1
			cur_num = x
		}
	}
	return best_seq
}

func dig_to_int(dig []int) int {
	n := 0
	for _, d := range dig {
		n = n*10 + d
	}
	return n
}

func int_to_dig(n int) []int {
	n_str := strconv.Itoa(n)
	digs := make([]int, len(n_str))

	for c_idx, c := range n_str {
		digs[c_idx] = int(c - '0')
	}
	return digs
}

func set_primes_6() int {
	primes_6_dig := primes(100_000, 1_000_000)
	primes_6_dig_arr := make([][]int, len(primes_6_dig))
	primes_6_sort_dig := make([]int, len(primes_6_dig))

	for idx, val := range primes_6_dig {
		primes_6_dig_arr[idx] = int_to_dig(val)
		sort.Ints(primes_6_dig_arr[idx])
		primes_6_sort_dig[idx] = dig_to_int(primes_6_dig_arr[idx])
	}

	sort.Ints(primes_6_sort_dig)
	return longest_seq(primes_6_sort_dig)
}

func main() {
	fmt.Println(set_primes_6())
	// fmt.Println(len(primes(100_000, 1_000_000)))
}
