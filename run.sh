#! usr/bin/env bash

hg19='/users/sofiapezoa/documents/molb7621/problem-set-4/data/hg19.chr1.fa'
index='/users/sofiapezoa/documents/molb7621/problem-set-4/data/hg19.chr1'
fastq='/users/sofiapezoa/documents/molb7621/problem-set-4/data/factorx.chr1.fq'

# make index with bowtie2-build
bowtie2-build $hg19 hg19.chr1

# use bowtie2 and samtools to align reads to index output is sorted bam
 bowtie2 -x $index -U $fastq | samtools sort -o factorx.sort.bam
# call peaks
 macs2 callpeak -t factorx.sort.bam

genome='/users/sofiapezoa/documents/molb7621/problem-set-4/data/hg19.chrom.sizes'
# make bedgraph and bigwig
 Bedtools genomecov -ibam factorx.sort.bam -g $genome -bg > factorx.bg
 bedGraphToBigWig factorx.bg $genome factorx.bw

 # UCSC track is
 # https://genome.ucsc.edu/cgi-bin/hgTracks?db=hg19&lastVirtModeType=default&lastVirtModeExtraState=&virtModeType=default&virtMode=0&nonVirtPosition=&position=chr1%3A41541771-207708851&hgsid=486252732_kidAGgpla2dRMERy6AwRdZzA2Srh

fasta='/users/sofiapezoa/documents/molb7621/problem-set-4/data/hg19.chr1.fa'
bedtools slop -i NA_summits.bed -g $genome -b 25 \
    | gshuf \
    | head -n 1000 > peaks.rand.1000.bed 
bedtools getfasta -fi $fasta -bed peaks.rand.1000.bed -fo factorx.1000.fa

meme factorx.1000.fa -nmotifs 1 -maxw 20 -minw 8 -dna 

meme-get-motif -id 1 < meme.txt

# Match in tomtom is CTCF! 
