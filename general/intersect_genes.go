package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strconv"
	"strings"
)

// var (
// 	chr   int
// 	start int
// 	end   int
// )

type dels struct {
	chr   int
	start int
	end   int
}

type genes struct {
	chr   int
	start int
	end   int
	name  string
}

var (
	g        genes
	d        dels
	delCount int
)

func main() {

	fgene, err := os.Open("/Users/bh10/Documents/Rotation3/scripts/general/test_genes.txt")
	if err != nil {
		log.Fatal(err)
	}
	defer fgene.Close()

	var geneAll []string

	sGene := bufio.NewScanner(fgene)
	for sGene.Scan() {
		geneAll = append(geneAll, sGene.Text())
	}

	if err := sGene.Err(); err != nil {
		log.Fatal(err)
	}

	fdel, err := os.Open("/Users/bh10/Documents/Rotation3/scripts/general/test_dels.txt")
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
	outPath := "/Users/bh10/Documents/Rotation3/scripts/general/"
	geneFullfile := "geneFullList.txt"

	geneOut := fmt.Sprintf("%v%v", outPath, geneFullfile)
	gOut, err := os.Create(geneOut)
	if err != nil {
		log.Fatalf("failed to create output %s: %v", geneOut, err)
	}
	defer gOut.Close()

	genefile := "geneList.txt"

	genesumOut := fmt.Sprintf("%v%v", outPath, genefile)
	gsOut, err := os.Create(genesumOut)
	if err != nil {
		log.Fatalf("failed to create output %s: %v", genesumOut, err)
	}
	defer gsOut.Close()

	// commence reading

	for _, rG := range geneAll {

		gspl := strings.Split(rG, "\t")

		gcf, _ := strconv.ParseFloat(gspl[0], 1)
		gsf, _ := strconv.ParseFloat(gspl[1], 1)
		gef, _ := strconv.ParseFloat(gspl[2], 1)

		gci := int(gcf)
		gsi := int(gsf)
		gei := int(gef)

		gname := gspl[3]

		g = genes{
			chr:   gci,
			start: gsi,
			end:   gei,
			name:  gname,
		}
		fmt.Println()
		fmt.Println("Gene for comparison:", g.chr, g.start, g.end, g.name)

		// make count of dels 0, before searching dels for a match
		delCount = 0

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
			fmt.Println("Current del: ", d.chr, d.start, d.end)

			// check chr the same
			if g.chr != d.chr {
				continue
			}

			if g.start <= d.end && g.end >= d.start {
				delType := characteriseDel(g.start, g.end, d.start, d.end)
				fmt.Println("Deletion found in gene, type: ", delType)

				var p float32
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

				fmt.Fprintf(gOut, "%v\t%v\t%v\t%v\t%v\t%v\t%v\t%v\n",
					g.name,
					g.chr,
					g.start,
					g.end,
					p,
					d.chr,
					d.start,
					d.end,
				)

				fmt.Fprintf(gsOut, "%v\t%v\t%v\t%v\t%v\n",
					g.name,
					g.chr,
					g.start,
					g.end,
					p,
				)
			}
			// If there is a del
			delCount++
		}
		// still print genes with no deletions for completeness
		fmt.Println("no genes in ", g.name)
		if delCount == 0 {
			fmt.Fprintf(gsOut, "%v\t%v\t%v\t%v\t%v\n",
				g.name,
				g.chr,
				g.start,
				g.end,
				0,
			)
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
