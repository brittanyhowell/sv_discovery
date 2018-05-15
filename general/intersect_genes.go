package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strconv"
	"strings"
)

type coordfile struct {
	chr   int
	start int
	end   int
}

var (
	chr   int
	start int
	end   int
)

// func readLines(path string) ([]string, error) {
// 	file, err := os.Open(path)
// 	if err != nil {
// 		return nil, err
// 	}
// 	defer file.Close()

// 	var lines []string
// 	scanner := bufio.NewScanner(file)
// 	for scanner.Scan() {
// 		lines = append(lines, scanner.Text())
// 	}
// 	return lines, scanner.Err()
// }

func main() {

	// lines, err := readLines("/Users/bh10/Documents/Rotation3/scripts/general/test_genes.txt")
	// if err != nil {
	// 	log.Fatalf("readLines: %s", err)
	// }
	// for i, line := range lines {
	// 	fmt.Println("num: ", i, "line: ", line[0])

	// dels = coordfile{
	// 	chr:   [0],
	// 	start: [1],
	// 	end:   [2],
	// }

	// }

	// var(
	// delfile     string
	// genefile string
	// )

	// delfile = "~/Documents/Rotation3/scripts/general/test_dels.txt"
	// genefile ="~/Documents/Rotation3/scripts/general/test_genes.txt"

	file, err := os.Open("/Users/bh10/Documents/Rotation3/scripts/general/test_genes.txt")
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	var geneAll []string

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		geneAll = append(geneAll, scanner.Text())
		fmt.Println("all:", scanner.Text())
	}

	if err := scanner.Err(); err != nil {
		log.Fatal(err)
	}
	// var dels coordfile
	for _, r := range geneAll {

		fmt.Println("The lines???", r)
		spl := strings.Split(r, "\t")

		fmt.Println("split: ", spl[2])

		cfloat, _ := strconv.ParseFloat(spl[0], 0)
		sfloat, _ := strconv.ParseFloat(spl[1], 1)
		efloat, _ := strconv.ParseFloat(spl[2], 1)

		chrom := int(cfloat)
		start := int(sfloat)
		end := int(efloat)

	}

	fmt.Println("Dels:", dels)
	// // This file NEEDS to be a BED3
	// locD, err := os.Open("/Users/bh10/Documents/Rotation3/scripts/general/test_genes.txt")
	// if err != nil {
	// 	log.Printf("error: could not open %s to read %v", locD, err)
	// }
	// defer locD.Close()

	// lr, err := bed.NewReader(locD, 3)
	// if err != nil {
	// 	log.Printf("error in NewReader: %s, %v", locD, err)
	// }

	// fsc := featio.NewScanner(lr)

	// for fsc.Next() {
	// 	f := fsc.Feat().(*bed.Bed3)
	// 	fmt.Printf("chr: %v, start: %v, end: %v, \n", f.Chrom, f.Start(), f.End())
	// }

	// locG, err := os.Open("/Users/bh10/Documents/Rotation3/scripts/general/test_genes.txt")
	// if err != nil {
	// 	log.Printf("error: could not open %s to read %v", locG, err)
	// }
	// defer locG.Close()

	// r, err := bed.NewReader(locG, 3)
	// if err != nil {
	// 	log.Printf("error in NewReader: %s, %v", locG, err)
	// }

	// gsc := featio.NewScanner(r)
	// fmt.Println("Genes:")
	// for gsc.Next() {
	// 	f := gsc.Feat().(*bed.Bed3)
	// 	fmt.Printf("chr: %v, start: %v, end: %v, \n", f.Chrom, f.Start(), f.End())
	// }

	// scanner := bufio.NewScanner(loc)

	// // var dels coordfile
	// var lines []string
	// for scanner.Scan() { // internally, it advances token based on seperator
	// 	// 	// line := scanner.Bytes()
	// 	// 	// fmt.Println("Line", string(line[0:4]))

	// 	// dels = coordfile{
	// 	// 	chr:   scanner.Text()[0],
	// 	// 	start: scanner.Text()[1],
	// 	// 	end:   scanner.Text()[2],
	// 	// }
	// 	// lines = append(lines, scanner.Text())
	// 	fmt.Println("some text", scanner.Text()) // token in unicode-char
	// 	// 	// fmt.Println(scanner.Bytes()) // token in bytes

	// 	dels = append(nodes, &Node{ipaddr: scanner.Text()})
	// 	fmt.Println(nodes[i])

	// }
	// fmt.Println("the lines: ", lines)
	// fmt.Println(dels)
}
