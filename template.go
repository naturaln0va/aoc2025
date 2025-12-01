// This script was written for the advent of code 2024 day X.
// https://adventofcode.com/2025/day/X

package main

import (
	"fmt"
	"io"
	"net/http"
	"os"
	"path/filepath"
	"strconv"
	"strings"
)

const year = 2025

type Solver struct {
	day  int
	year int
}

func NewSolver(day int) *Solver {
	return &Solver{day: day, year: year}
}

func (s *Solver) FetchInput() string {
	inputDir := "input"
	if err := os.MkdirAll(inputDir, 0755); err != nil {
		panic(err)
	}

	filename := filepath.Join(inputDir, fmt.Sprintf("day%02d.txt", s.day))

	if data, err := os.ReadFile(filename); err == nil {
		return strings.TrimRight(string(data), "\n")
	}

	cookie, err := os.ReadFile("cookie.txt")
	if err != nil {
		panic("cookie.txt not found - add your session cookie")
	}

	url := fmt.Sprintf("https://adventofcode.com/%d/day/%d/input", s.year, s.day)
	req, _ := http.NewRequest("GET", url, nil)
	req.Header.Set("Cookie", fmt.Sprintf("session=%s", strings.TrimSpace(string(cookie))))

	resp, err := http.DefaultClient.Do(req)
	if err != nil {
		panic(err)
	}
	defer resp.Body.Close()

	body, _ := io.ReadAll(resp.Body)
	if err := os.WriteFile(filename, body, 0644); err != nil {
		panic(err)
	}

	return strings.TrimRight(string(body), "\n")
}

func (s *Solver) TestCase(input string, expected1, expected2 any) {
	if expected1 != nil {
		result := s.SolveFirst(input)
		if result == expected1 {
			fmt.Printf("✓ Part 1 test passed: %v\n", result)
		} else {
			fmt.Printf("✗ Part 1 test failed: got %v, expected %v\n", result, expected1)
		}
	}

	if expected2 != nil {
		result := s.SolveSecond(input)
		if result == expected2 {
			fmt.Printf("✓ Part 2 test passed: %v\n", result)
		} else {
			fmt.Printf("✗ Part 2 test failed: got %v, expected %v\n", result, expected2)
		}
	}
}

func (s *Solver) SolveFirst(input string) any {
	lines := strings.Split(input, "\n")
	_ = lines // use lines

	return nil
}

func (s *Solver) SolveSecond(input string) any {
	lines := strings.Split(input, "\n")
	_ = lines // use lines

	return nil
}

// Helper: parse lines into []int
func parseInts(input string) []int {
	var nums []int
	for _, line := range strings.Split(input, "\n") {
		if n, err := strconv.Atoi(line); err == nil {
			nums = append(nums, n)
		}
	}
	return nums
}

// Helper: parse space-separated ints from a line
func parseLineInts(line string) []int {
	var nums []int
	for _, s := range strings.Fields(line) {
		if n, err := strconv.Atoi(s); err == nil {
			nums = append(nums, n)
		}
	}
	return nums
}

func main() {
	solver := NewSolver(1)

	// Test with example input
	testInput := ``
	solver.TestCase(testInput, nil, nil)

	// Solve with real input
	input := solver.FetchInput()
	fmt.Println("Part 1:", solver.SolveFirst(input))
	fmt.Println("Part 2:", solver.SolveSecond(input))
}
