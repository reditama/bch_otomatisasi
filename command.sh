#!/bin/sh


#PARAMETER#
input=Sample_1
minqual=20
minleng=100
#output=$input"_trim"
output=trim

##QUALITY CONTROL##
echo "======================================================="
echo "====================QUALITY CONTROL===================="
echo "======================================================="
echo Input file: $1
echo Output file: $output.fastq
echo "-------------------------------------------------------"
fastq_quality_trimmer -t $minqual -l $minleng -i $1 -o $output.fastq
echo "-------------------------------------------------------"
echo ""
echo "------------> Quality control succeed \m/ <------------"
echo ""

##REMOVE DUPLICATES##
input2=$output
output2=$output"_unique"
echo "======================================================="
echo "===================REMOVE DUPLICATES==================="
echo "======================================================="
echo Input file: $input2.fastq
echo Output file: $output2.fastq
echo ""
echo "-------------------------------------------------------"
usearch -fastx_uniques $input2.fastq -fastaout $output2.fasta -sizeout -relabel Uniq
echo "-------------------------------------------------------"
echo ""
echo "-----------> Remove duplicates succeed \m/ <-----------"
echo ""

##CLUSTERING##
input3=$output2
output3a=$output2"_otus"
output3b=$output2"_out"
echo "======================================================="
echo "===========CLUSTERING AND CHIMERA FILTERING============"
echo "======================================================="
echo "Input file: $input3.fasta"
echo "Output file: $output3a.fasta, $output3b.up"
echo ""
echo "-------------------------------------------------------"
usearch -cluster_otus $input3.fasta -otus $output3a.fasta -uparseout $output3b.up -relabel OTU -minsize 2
echo "-------------------------------------------------------"
echo ""
echo "---> Clustering and chimera filtering succeed \m/ <----"
