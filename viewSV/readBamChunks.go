// Comment I guess?
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

// Specifically the auxfields needed for this analysis.
type auxfields struct {
	X0 sam.Tag
	X1 sam.Tag
	XT sam.Tag
	XN sam.Tag
}

var (
	fSplice    bool
	index      string
	bamFile    string
	intFile    string
	outPath    string
	outName    string
	sampleName string
)
var (
	sv SVfile
)

func main() {
	// For reference,
	//the first is the variable,
	//the second is the flag for the call command,
	//the third is default,
	//the fourth is the description
	flag.StringVar(&index, "index", "", "name index file")
	flag.StringVar(&bamFile, "bam", "", "name bam file")
	flag.StringVar(&sampleName, "sample", "", "name of sample")
	flag.StringVar(&intFile, "intFile", "", "Interval File")
	flag.StringVar(&outPath, "outPath", "", "path to reads output DIR")

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

	// Read in the SV table
	fInt, err := os.Open(intFile)
	if err != nil {
		log.Fatal(err)
	}
	defer fInt.Close()

	var intAll []string
	sInt := bufio.NewScanner(fInt)
	i := 0
	for sInt.Scan() {
		if i > 0 { // IMPORTANT - ASSUMES THERE IS A HEADER, ELSE IT WILL SKIP THE FIRST SV
			intAll = append(intAll, sInt.Text())
		}
		i++
	}
	fmt.Println(intAll)
	if err := sInt.Err(); err != nil {
		log.Fatal(err)
	}

	var howManyReads int
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
		//print the intervals
		fmt.Printf("Interval: %v\t%v\t%v\t%v\t%v\t%v\n", sv.Chr, sv.Start, sv.End, sv.Name, sv.Length, sv.TypeofSV)
		outName = fmt.Sprintf("%v_%v_reads.txt", sampleName, sv.Name)

		// Creating single file for the current output SV
		file := fmt.Sprintf("%v%v", outPath, outName)
		out, err := os.Create(file)
		if err != nil {
			log.Fatalf("failed to create out %s: %v", file, err)
		}
		defer out.Close()

		// Currently no reads for this interval
		howManyReads = 0

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
			howManyReads++
			// print each read to a file, get the coordinates and print, yeah
			r := i.Record()
			start := r.Pos
			stop := r.Pos + r.TempLen

			// Aux tags available with BWA mem 16-7-18:
			// X0 Number of best hits
			// X1 Number of suboptimal hits found by BWA
			// XN Number of ambiguous bases in the referenece
			// XM Number of mismatches in the alignment
			// XO Number of gap opens
			// XG Number of gap extentions
			// XT Type: Unique/Repeat/N/Mate­sw
			// XA Alternative hits; format: (chr,pos,CIGAR,NM;)*
			// XS Suboptimal alignment score
			// XF Support from forward/reverse alignment
			// XE Number of supporting seeds

			// checkAux

			tagXT := sam.NewTag("XT") // Type: Unique/Repeat/N/Mate­sw
			tagX1 := sam.NewTag("X1") // number of sub optimal hits
			tagX0 := sam.NewTag("X0") // number of best hits (in multiple mapping cases) (v. important)
			tagXN := sam.NewTag("XN") // number of ambiguous bases in the alignment

			valXT := r.AuxFields.Get(tagXT)
			valX0 := r.AuxFields.Get(tagX0)
			valX1 := r.AuxFields.Get(tagX1)
			valXN := r.AuxFields.Get(tagXN)

			var countVars int
			countVars = 0
			if valXT != nil {
				countVars++
			}
			if valX0 != nil {
				countVars++
			}
			if valX1 != nil {
				countVars++
			}
			if valXN != nil {
				countVars++
			}

			// OKAY SO
			// Now that countVars equals the number of nil values (that aren't NIL) we can adjust the file output.
			// Either, print dashes. Dots. SOMETHING. OR print the value. Don't make it zero, zero carries meaning.
			// an idea is NIL.
			// we're talkin':if countVars == 4, print lomg, if not, print nils
			fmt.Fprintf(out, "%v\t%v\t%v\t%v\t%v\n\n%v\n\nvalues:%v\tX1:%v\tXT:%v\tXN:%v\n",
				sv.Chr,  // Chromosome - yes it is of the SV not the read but if it maps it has to match so it should be fine.
				start,   // start mapping
				stop,    // stop mapping
				r.Cigar, // cigar string
				r.MapQ,  // read quality
				r.AuxFields,
				countVars,
				countVars,
				countVars,
				countVars,
				// len(r.AuxFields.Get(tagXN)),
			)

		}
		fmt.Printf("There were %v reads in the interval %v\n", howManyReads, sv.Name)

	}
}
