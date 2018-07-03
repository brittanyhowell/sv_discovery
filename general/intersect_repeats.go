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

type repeats struct {
	chr    int
	start  int
	end    int
	class  string
	family string
}

var (
	g        repeats
	d        dels
	delCount int

	currentChrom int
	p            float32

	repeatIn  string
	delIn     string
	outPath   string
	repeatOut string
)

func main() {
	flag.StringVar(&repeatIn, "repeatIn", "", "Input repeat list")
	flag.StringVar(&delIn, "delIn", "", "input deletion list")
	flag.StringVar(&outPath, "outPath", "", "Output file path")
	// flag.StringVar(&SJMap3, "SJMap3", "", "repeat (expanded) file")
	flag.StringVar(&repeatOut, "repeatOut", "", "repeat (summary) file")
	flag.Parse()

	frepeat, err := os.Open(repeatIn)
	if err != nil {
		log.Fatal(err)
	}
	defer frepeat.Close()

	var repeatAll []string

	srepeat := bufio.NewScanner(frepeat)
	for srepeat.Scan() {
		repeatAll = append(repeatAll, srepeat.Text())
	}

	if err := srepeat.Err(); err != nil {
		log.Fatal(err)
	}

	fdel, err := os.Open(delIn)
	if err != nil {
		log.Fatal(err)
	}
	defer fdel.Close()

	var delsAll []string

	sDel := bufio.NewScanner(fdel)
	i := 0
	for sDel.Scan() {
		if i > 0 { // IMPORTANT - ASSUMES THERE IS A HEADER, ELSE IT WILL SKIP THE FIRST DEL
			delsAll = append(delsAll, sDel.Text())
		}
		i++
	}

	if err := sDel.Err(); err != nil {
		log.Fatal(err)
	}

	// Add this one back in if you want to list specifically the deletions which took out the repeat
	// repeatFullfile := "repeatFullList.txt"

	// repeatOut := fmt.Sprintf("%v%v", outPath, repeatFullfile)
	// gOut, err := os.Create(repeatOut)
	// if err != nil {
	// 	log.Fatalf("failed to create output %s: %v", repeatOut, err)
	// }
	// defer gOut.Close()

	repeatsumOut := fmt.Sprintf("%v%v", outPath, repeatOut)
	gsOut, err := os.Create(repeatsumOut)
	if err != nil {
		log.Fatalf("failed to create output %s: %v", repeatsumOut, err)
	}
	defer gsOut.Close()

	// commence reading

	for _, rD := range delsAll {
		dspl := strings.Split(rD, "\t")

		dcf, _ := strconv.ParseFloat(dspl[0], 1)
		dsf, _ := strconv.ParseFloat(dspl[1], 1)
		def, _ := strconv.ParseFloat(dspl[2], 1)

		dci := int(dcf)
		dsi := int(dsf)
		dei := int(def)

		d = dels{
			chr:   dci,
			start: dsi,
			end:   dei,
		}

		// fmt.Println("repeat for comparison:", g.chr, g.start, g.end, g.name)

		if currentChrom != d.chr {
			fmt.Println("working on chromosome: ", d.chr)
		}
		currentChrom = d.chr

		for _, rG := range repeatAll {
			// make count of dels 0, before searching dels for a match
			delCount = 0

			gspl := strings.Split(rG, "\t")

			gcf, _ := strconv.ParseFloat(gspl[0], 1)
			gsf, _ := strconv.ParseFloat(gspl[1], 1)
			gef, _ := strconv.ParseFloat(gspl[2], 1)

			gci := int(gcf)
			gsi := int(gsf)
			gei := int(gef)

			gclass := gspl[3]
			gfam := gspl[4]

			g = repeats{
				chr:    gci,
				start:  gsi,
				end:    gei,
				class:  gclass,
				family: gfam,
			}

			// check chr the same
			if g.chr != d.chr {
				continue
			}
			if g.start <= d.end && g.end >= d.start {
				// If there is a del
				delCount++

				delType := characteriseDel(g.start, g.end, d.start, d.end)

				switch delType {
				case "within":
					p = calcOverlap(d.end, d.start, g.end, g.start)
				case "overspill":
					p = 1
				case "spillLeft":
					p = calcLeftSpill(d.end, d.start, g.end, g.start)
				case "spillRight":
					p = calcRightSpill(d.end, d.start, g.end, g.start)
				}

				fmt.Println("p: ", p)

				// fmt.Fprintf(gOut, "%v\t%v\t%v\t%v\t%v\t%v\t%v\t%v\n",
				// 	g.name,
				// 	g.chr,
				// 	g.start,
				// 	g.end,
				// 	p,
				// 	d.chr,
				// 	d.start,
				// 	d.end,
				// )
			}

			// Change print to include DELs,
			if delCount == 1 {
				fmt.Fprintf(gsOut, "%v_%v:%v\t%v_%v_%v_%v:%v\t%v\n",
					d.chr,
					d.start,
					d.end,
					g.class,
					g.family,
					g.chr,
					g.start,
					g.end,
					p,
				)
			} else {
				fmt.Fprintf(gsOut, "%v_%v:%v\t%v_%v_%v_%v:%v\t%v\n",
					d.chr,
					d.start,
					d.end,
					g.class,
					g.family,
					g.chr,
					g.start,
					g.end,
					delCount,
				)
			}

		}
	}
}

func characteriseDel(gstart, gend, dstart, dend int) string {
	var delType string

	switch {
	case gstart <= dstart && gend >= dend:
		delType = "within"
	case gstart >= dstart && gend <= dend:
		delType = "overspill"
	case gstart >= dstart && gend >= dend:
		delType = "spillLeft"
	case gstart <= dstart && gend <= dend:
		delType = "spillRight"
	}
	return delType

}

func calcRightSpill(dend, dstart, gend, gstart int) float32 {
	oLen := g.end - d.start
	genLen := g.end - g.start
	var p float32
	p = float32(oLen) / float32(genLen)
	return p
}

func calcLeftSpill(dend, dstart, gend, gstart int) float32 {
	oLen := d.end - g.start
	genLen := g.end - g.start
	var p float32
	p = float32(oLen) / float32(genLen)
	return p
}

func calcOverlap(dend, dstart, gend, gstart int) float32 {

	delLen := d.end - d.start
	genLen := g.end - g.start
	var p float32
	p = float32(delLen) / float32(genLen)
	return p
}
