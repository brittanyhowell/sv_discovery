// attempt at reading a bam.
package main

import (
	"bufio"
	"flag"
	"fmt"
	"log"
	"os"
	"strconv"
	"strings"

	"github.com/biogo/hts/bam"
	"github.com/biogo/hts/sam"
)

// SVfile represents SV information file
type SVfile struct {
	Chr      string
	Start    int
	End      int
	Name     string
	Length   int
	TypeofSV string
}

var (
	fSplice bool
	index   string
	bamFile string
	intFile string
	outPath string
	outName string
)
var (
	sv SVfile
)

func main() {

	flag.StringVar(&index, "index", "", "name index file")
	flag.StringVar(&bamFile, "bam", "", "name bam file")
	flag.StringVar(&intFile, "intFile", "", "Interval File")
	flag.StringVar(&outPath, "outPath", "", "path to output dir")
	flag.StringVar(&outName, "outName", "", "out file name")
	flag.Parse()

	fmt.Println("Begin")

	// read index
	ind, err := os.Open(index)
	if err != nil {
		log.Printf("error: could not open %v to read %v", ind, err)
	}
	defer ind.Close()
	bai, err := bam.ReadIndex(ind)
	h := bai.NumRefs()

	// Read bam
	f, err := os.Open(bamFile)
	if err != nil {
		log.Printf("error: could not open %v to read %v", f, err)
	}
	defer f.Close()
	var br *bam.Reader
	br, err = bam.NewReader(f, 0)
	if err != nil {
		log.Printf("error: %v, %v", br, err)
	}
	defer br.Close()

	// store bams
	refs := make(map[string]*sam.Reference, h)
	for _, r := range br.Header().Refs() {
		refs[r.Name()] = r
	}

	// Creating files for the output
	file := fmt.Sprintf("%v%v", outPath, outName)
	out, err := os.Create(file)
	if err != nil {
		log.Fatalf("failed to create out %s: %v", file, err)
	}
	defer out.Close()

	// Read in the SV table
	fInt, err := os.Open(intFile)
	if err != nil {
		log.Fatal(err)
	}
	defer fInt.Close()

	var intAll []string
	sInt := bufio.NewScanner(fInt)
	for sInt.Scan() {
		intAll = append(intAll, sInt.Text())
	}
	if err := sInt.Err(); err != nil {
		log.Fatal(err)
	}

	// Read intervals line by line
	for _, rInt := range intAll {
		splitInt := strings.Split(rInt, "\t")

		intStart, _ := strconv.ParseFloat(splitInt[1], 1)
		intStop, _ := strconv.ParseFloat(splitInt[2], 1)
		intLen, _ := strconv.ParseFloat(splitInt[4], 1)

		intStartint := int(intStart)
		intStopint := int(intStop)
		intLenint := int(intLen)

		intChr := splitInt[0]
		intID := splitInt[3]
		intType := splitInt[5]

		sv = SVfile{
			Chr:      intChr,
			Start:    intStartint,
			End:      intStopint,
			Name:     intID,
			Length:   intLenint,
			TypeofSV: intType,
		}

		// set chunks - based on intervals
		chunks, err := bai.Chunks(refs[sv.Chr], sv.Start, sv.End)
		if err != nil {
			fmt.Println(chunks, err)
			// continue
		}

		i, err := bam.NewIterator(br, chunks)
		if err != nil {
			log.Fatal(err)
		}

		// iterate over reads - print to file
		for i.Next() {
			// print each read to a file, get the coordinates and print, yeah
			r := i.Record()
			fmt.Println("Looks like we got a read boiz:\t", r.Pos, "\t", r.Cigar, "\t", r.TempLen)
			// fmt.Fprintf(out) // r.Pos,
			// Oh noo I have to work out which bits are mapped. What if it's split ??
			//Look yp the name of a chromosome, you toast,
			// You're going to have to get the start position, consume the reference, until you get the full length of it. eugh.
			// Also do we want to this to be SO uninformative?
			// Are we going to reduce it to a list of coordinates.
			// No, we are going to also print the cigar string and plot like a good noodle.
			// Remember that "TLEN can be used."

		}

	}
}
