bsub -q long -o /nfs/team151/bh10/scripts/genomestrip_bh10/output/preprocess.CRAM.%J.out -e /nfs/team151/bh10/scripts/genomestrip_bh10/output/preprocess.CRAM.%J.err -R"select[mem>20000] rusage[mem=20000]" -M20000 "/nfs/team151/bh10/scripts/genomestrip_bh10/preprocess.sh INTERVAL_WG_pre /nfs/team151/bh10/scripts/genomestrip_bh10/cramList.list"
 
 
bsub -q long -o /nfs/team151/bh10/scripts/genomestrip_bh10/output/n_disc.twoTest.%J.out -e /nfs/team151/bh10/scripts/genomestrip_bh10/output/n_disc.twoTest.%J.err -R"select[mem>10000] rusage[mem=10000]" -M10000 "/nfs/team151/bh10/scripts/genomestrip_bh10/discovery.sh INTERVAL_WG_disc_two"
 
took about 7 hours, needed 1406M mem
 
 
 
bsub -q long -o /lustre/scratch115/realdata/mdt3/projects/pagedata/data_freezes/2017-06-24_WGS/genomestrip/farmout/geno.out.%J -e /lustre/scratch115/realdata/mdt3/projects/pagedata/data_freezes/2017-06-24_WGS/genomestrip/farmout/geno.err.%J -R"select[mem>5000] rusage[mem=5000]" -M5000 "/lustre/scratch115/realdata/mdt3/projects/pagedata/data_freezes/2017-06-24_WGS/genomestrip/genotyping.sh PAGE_WGS /lustre/scratch115/realdata/mdt3/projects/pagedata/data_freezes/2017-06-24_WGS/genomestrip/input_bam_files.list"
 
ran in 10 hours, 1646 M mem
 
 
bsub -q long -o /lustre/scratch115/realdata/mdt3/projects/pagedata/data_freezes/2017-06-24_WGS/genomestrip/farmout/profiles.out.%J -e /lustre/scratch115/realdata/mdt3/projects/pagedata/data_freezes/2017-06-24_WGS/genomestrip/farmout/profiles.err.%J -R"select[mem>5000] rusage[mem=5000]" -M5000 "/lustre/scratch115/realdata/mdt3/projects/pagedata/data_freezes/2017-06-24_WGS/genomestrip/build_profiles.sh /lustre/scratch115/realdata/mdt3/projects/pagedata/data_freezes/2017-06-24_WGS/genomestrip/PAGE_WGS.tar.gz 10000"
ran in ~1 hour 1400M mem
 
 
bsub -q long -o /lustre/scratch115/realdata/mdt3/projects/pagedata/data_freezes/2017-06-24_WGS/genomestrip/farmout/cnv.out.%J -e /lustre/scratch115/realdata/mdt3/projects/pagedata/data_freezes/2017-06-24_WGS/genomestrip/farmout/cnv.err.%J -R"select[mem>5000] rusage[mem=5000]" -M5000 "/lustre/scratch115/realdata/mdt3/projects/pagedata/data_freezes/2017-06-24_WGS/genomestrip/cnv_discovery.sh /lustre/scratch115/realdata/mdt3/projects/pagedata/data_freezes/2017-06-24_WGS/genomestrip/input_bam_files.list"
 
ran in ~6 hours 1700 M mem
 
 
 
bsub -q long -o /lustre/scratch115/realdata/mdt3/projects/pagedata/data_freezes/2017-06-24_WGS/genomestrip/farmout/lcnv.out.%J -e /lustre/scratch115/realdata/mdt3/projects/pagedata/data_freezes/2017-06-24_WGS/genomestrip/farmout/lcnv.err.%J -R"select[mem>5000] rusage[mem=5000]" -M5000 "/lustre/scratch115/realdata/mdt3/projects/pagedata/data_freezes/2017-06-24_WGS/genomestrip/run_lcnv_pipeline.sh /lustre/scratch115/realdata/mdt3/projects/pagedata/data_freezes/2017-06-24_WGS/genomestrip/samples.list" 
 
completed but without the farm job ending - so killed farm job
 
