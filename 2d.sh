#!/bin/sh

##Description: bash script for oil palm 2d simulation


##EXTRACT ALIGNMENT 
input=Akar0.sam
target=/home/bioinformatics3/indexdb/Eg_NCBI_mRNA_PSI/Eg_NCBI_mRNA_PSI.fasta


echo "=======EXTRACT ALIGNMENT========="
echo Input file: $input
echo ""
echo "================================="
express --fr-stranded $target $input
echo "================================="

##CONVERT EXPRESS OUTPUT
input1=results.xprs
tpm_min=50
output1=xprs_out.csv

echo "=====CONVERT EXPRESS OUTPUT======"
echo Input file: $input1
echo Output file: $output1
echo ""
echo "================================="
Rscript xprs.r -i $input1 -t $tpm_min -o $output1
echo "================================="
echo ""
echo "->END OF CONVERT EXPRESS OUTPUT<-"
echo ""

##2D PLOTTING##
input2=$output1
output2=plot_xprs.png
imres=l
logbase=10

echo "=========MODEL CONSTRUCTION======="
echo Input file: $input2
echo Output file: $output2
echo ""
echo "=================================="
Rscript 2d.r -i $input2 -o $output2 -r $imres -b $logbase -l y -m n
echo "=================================="
echo ""
echo "--->END OF MODEL CONSTRUCTION<---"
