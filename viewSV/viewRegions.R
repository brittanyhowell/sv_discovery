# Plot reads to visualise SVs


# Load
  library(IRanges)
  library(ggplot2)
  library(ggvis)
  
  reads <- read.table("~/Documents/Rotations/Rotation3/data/testView/reads/EGAN00001214492_CNV_chr1_930465_932077_reads.txt", sep = "\t")
  info <- read.table("/Users/bh10/Documents/Rotations/Rotation3/data/testView/")
  colnames(reads) <- c("name", "chr","start","end","cigar","mapq","AS")
  
  
# Process as IRanges
  start = reads$start
  end = reads$end
  intervals <- IRanges(start = start, end = end)
  head(intervals)

# Plot Coverage
  cov <- coverage(intervals)
  par(mar=c(5,6,4,1)+.1)
  plot(cov,type = "l", xlim = c(929000, 933000),panel.first={
    grid( col ="gray88") 
  }, xlab = "chromosome coordinate",ylab= "", las=1)
  segments(930465,0,932077,0,col ="cornflowerblue",lwd=3) # plot the SV coordinates

# Function to plot boxy boxes in base R
  plotRanges <- function(x, xlim = x, main = "EGAN00001214492_CNV_chr1_930465_932077_reads.txt",
                         col = "black", sep = .1,borderStart = SVstart-1000, borderEnd = SVend+1000, ...)
  {
    height <- .2
    if (is(xlim, "Ranges"))
      xlim <- c(929000, 934000)#xlim <- c(min(start(xlim)), max(end(xlim)))
    bins <- disjointBins(IRanges(start(x), end(x) + 1))
    plot.new()
    plot.window(xlim, c(0, max(bins)*(height + sep)))
    ybottom <- bins * (sep + height) - height
    rect(start(x)-0.5, ybottom, end(x)+0.5, ybottom + height, col = col, ...)
    title(main)
    axis(side=1,at=seq(929000,934000,by=1000),tcl=0.4,lwd.ticks=1,mgp=c(10,.2,0))#    axis(1)
  }
  
  plotRanges(intervals)
  
  
# Plot using ggplot
  
  # Function to classify cigar string
    cigarConvert <- function(x) {
      if (x == "151M") {
        val <- "151M"
      } else {
        val <- "other"
      }
      return(val)
    }
    
  # Change cigar string to '151M' or 'other'
    cigar.bool <- as.data.frame(sapply(reads$cigar,cigarConvert))
    
    test <- cbind(dat,cigar.bool,reads$cigar)
    colnames(test) <- c("start", "end", "width", "bin", "cigarClass","cigar")
    head(n=100,test)
    
    # ggplot - stacked bar plot
      bins <- disjointBins(IRanges(start(intervals), end(intervals) + 1))
      dat <- cbind(as.data.frame(intervals), bin = bins)
    
      ggplot(test) + 
      geom_rect(aes(xmin = start, xmax = end,
                    ymin = bin, ymax = bin + 0.9, fill = cigarClass)) +
      scale_x_continuous(limits = c(929000, 934000)) +
      theme_bw() + 
      geom_segment(aes(x = 930465, y = 0, xend = 932077, yend = 0)) + 
      scale_fill_manual(values=c( "black", "cornflowerblue"))

## get ggvis workin'
      # load dataset
      dataset <- read.csv("http://dl.dropboxusercontent.com/u/232839/DO_liver_variability_sex.csv", as.is=TRUE)
      head(dataset)
      
      # what to do on hover
      on_hover <- function(x) {
        if(is.null(x)) return(NULL)
        mgi_symbol <- dataset$Associated.Gene.Name[x$id]
        mgi_symbol
      }
      
      # what to do on click
      on_click <- function(x) {
        if(is.null(x)) return(NULL)
        ensid <- dataset$Ensembl.Gene.ID[x$id]
        ensembl_url <- paste0("http://useast.ensembl.org/Mus_musculus/Gene/Summary?db=core;g=", ensid)
        browseURL(ensembl_url)
        NULL
      }
      
      # start ggvis
      point_size = 100 # if dots are too big/small, adjust this parameter
      dataset %>% 
        ggvis(~protein.Sex, ~mrna.Sex, key := ~id) %>% 
        layer_points(size := point_size) %>%
        add_tooltip(on_hover, "hover") %>%
        add_tooltip(on_click, "click") %>% set_options(width=600, height=600)
      
  # Here for more ideas: https://ggvis.rstudio.com/layers.html