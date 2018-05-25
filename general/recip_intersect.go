package main

import (
	"bufio"
	"flag"
	"fmt"
	"log"
	"os"
	"strconv"
	"strings"
)

type dels struct {
	chr   int
	start int
	end   int
}

type genes struct {
	chr   int
	start int
	end   int
}

var (
	a     genes
	b     dels
	count int

	currentChrom int
	pA           float32
	pB           float32

	oneIn   string
	twoIn   string
	outPath string
	out     string
)

func main() {
	flag.StringVar(&oneIn, "oneIn", "", "Input gene list")
	flag.StringVar(&twoIn, "twoIn", "", "input deletion list")
	flag.StringVar(&outPath, "outPath", "", "Output file path")
	// flag.StringVar(&SJMap3, "SJMap3", "", "gene (expanded) file")
	flag.StringVar(&out, "out", "intersect.out", "gene (summary) file")
	flag.Parse()

	fA, err := os.Open(oneIn)
	// fA, err := os.Open("testA")
	if err != nil {
		log.Fatal(err)
	}
	defer fA.Close()

	var aAll []string
	i := 0
	sA := bufio.NewScanner(fA)
	for sA.Scan() {
		if i > 0 { // IMPORTANT - ASSUMES THERE IS A HEADER, ELSE IT WILL SKIP THE FIRST DEL
			aAll = append(aAll, sA.Text())
		}
		i++
	}

	if err := sA.Err(); err != nil {
		log.Fatal(err)
	}

	fB, err := os.Open(twoIn)
	// fB, err := os.Open("testB")
	if err != nil {
		log.Fatal(err)
	}
	defer fB.Close()

	var bAll []string

	sB := bufio.NewScanner(fB)
	i = 0
	for sB.Scan() {
		if i > 0 { // IMPORTANT - ASSUMES THERE IS A HEADER, ELSE IT WILL SKIP THE FIRST DEL
			bAll = append(bAll, sB.Text())
		}
		i++
	}

	if err := sB.Err(); err != nil {
		log.Fatal(err)
	}

	sumOut := fmt.Sprintf("%v%v", outPath, out)
	// sumOut := "intersect.out"
	gsOut, err := os.Create(sumOut)
	if err != nil {
		log.Fatalf("failed to create output %s: %v", sumOut, err)
	}
	defer gsOut.Close()

	// commence reading

	for _, rA := range aAll {
		// make count of dels 0, before searching dels for a match

		gspl := strings.Split(rA, "\t")

		gcf, _ := strconv.ParseFloat(gspl[0], 1)
		gsf, _ := strconv.ParseFloat(gspl[1], 1)
		gef, _ := strconv.ParseFloat(gspl[2], 1)

		gci := int(gcf)
		gsi := int(gsf)
		gei := int(gef)

		// gname := gspl[3]

		a = genes{
			chr:   gci,
			start: gsi,
			end:   gei,
		}
		// fmt.Println("Gene for comparison:", a.chr, a.start, a.end, a.name)

		if currentChrom != a.chr {
			fmt.Println("Total ", count, "intersects in chromosome", currentChrom)
			count = 0
			fmt.Println("working on chromosome: ", a.chr)
		}

		currentChrom = a.chr

		for _, rB := range bAll {
			dspl := strings.Split(rB, "\t")

			dcf, _ := strconv.ParseFloat(dspl[0], 1)
			dsf, _ := strconv.ParseFloat(dspl[1], 1)
			def, _ := strconv.ParseFloat(dspl[2], 1)

			dci := int(dcf)
			dsi := int(dsf)
			dei := int(def)

			b = dels{
				chr:   dci,
				start: dsi,
				end:   dei,
			}

			// check chr the same
			if a.chr != b.chr {
				continue
			}
			if a.start <= b.end && a.end >= b.start {

				delType := characteriseInt(a.start, a.end, b.start, b.end)

				switch delType {
				case "aOver":
					pA, pB = calc_aOver(b.end, b.start, a.end, a.start)
				case "bOver":
					pA, pB = calc_bOver(b.end, b.start, a.end, a.start)
				case "spillLeft":
					pA, pB = calcLeftSpill(b.end, b.start, a.end, a.start)
				case "spillRight":
					pA, pB = calcRightSpill(b.end, b.start, a.end, a.start)
				}

				if pA >= 0.8 && pB >= 0.8 {

					fmt.Fprintf(gsOut, "%v\t%v\t%v\t%v\t%v\t%v\t%v\t%v\t\n",
						a.chr,
						a.start,
						a.end,
						pA,
						b.chr,
						b.start,
						b.end,
						pB,
					)
					count++
				}

			}

		}
	}
}

func characteriseInt(gstart, gend, dstart, dend int) string {
	var delType string

	switch {
	case gstart <= dstart && gend >= dend:
		delType = "aOver"
	case gstart >= dstart && gend <= dend:
		delType = "bOver"
	case gstart >= dstart && gend >= dend:
		delType = "spillLeft"
	case gstart <= dstart && gend <= dend:
		delType = "spillRight"
	}
	return delType

}

// This can obviously be tidied
func calcRightSpill(dend, dstart, gend, gstart int) (pA, pB float32) {
	oLen := a.end - b.start
	aLen := a.end - a.start
	bLen := b.end - b.start

	pA = float32(oLen) / float32(aLen)
	pB = float32(oLen) / float32(bLen)
	return pA, pB
}

func calcLeftSpill(dend, dstart, gend, gstart int) (pA, pB float32) {
	oLen := b.end - a.start
	aLen := a.end - a.start
	bLen := b.end - b.start

	pA = float32(oLen) / float32(aLen)
	pB = float32(oLen) / float32(bLen)
	return pA, pB
}

func calc_aOver(dend, dstart, gend, gstart int) (pA, pB float32) {
	aLen := a.end - a.start
	bLen := b.end - b.start
	oLen := bLen

	pA = float32(oLen) / float32(aLen)
	pB = float32(oLen) / float32(bLen)
	return pA, pB
}

func calc_bOver(dend, dstart, gend, gstart int) (pA, pB float32) {
	bLen := b.end - b.start
	aLen := a.end - a.start
	oLen := aLen

	pA = float32(oLen) / float32(aLen)
	pB = float32(oLen) / float32(bLen)
	return pA, pB
}
