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

type hats struct {
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

var g genes
var d hats

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
		fmt.Println("this is the gene", g.chr, g.start, g.end, g.name)

		for _, rD := range delsAll {

			dspl := strings.Split(rD, "\t")

			dcf, _ := strconv.ParseFloat(dspl[0], 1)
			dsf, _ := strconv.ParseFloat(dspl[1], 1)
			def, _ := strconv.ParseFloat(dspl[2], 1)

			dci := int(dcf)
			dsi := int(dsf)
			dei := int(def)

			d = hats{
				chr:   dci,
				start: dsi,
				end:   dei,
			}

			fmt.Println("3 from dels", d.chr, d.start, d.end)

		}
	}
}

// fmt.Println("Dels:", dels)
