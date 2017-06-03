#!/bin/sh


##Description: bash script for automatic amplicon ngs analysis

#########################
# The command line help #
#########################
display_help() {
	echo "Usage: $0 [options...] -i <input.fastq>" >&2
	echo ""
	echo "Required arguments"
	echo "    -i, --input    	input file in FASTQ format"
	echo ""
	echo "Optional arguments"
	echo "    -q, --minqual   	minimum quality for FASTQ QC (default = 20)"
	echo "    -l, --minlength 	minimum length for FASTQ QC (default = 100) "
	echo "    -s, --sizeout  	FLAG for print sequence length in FASTA header (default = TRUE)"
	echo ""
	exit 1
}

########################################
# Command line argument implementation #
########################################
while :
do
	case "$1" in
	  -i | --input)
	      if [ $# -ne 0 ]; then
	        input=$2
	      fi
	      shift 2
	      ;;
	  -q | --minqual)
	      minqual=$2
	      shift 2
	      ;;
	  -l | --minlength)
	      minlength=$2
	      shift 2
	      ;;
	  -s | --sizeout)
	      if [ "$2" = "" ]; then
	        so=1
	      else if [ "$2" = "TRUE" ]; then
	        so=1
	      else if [ "$2" = "T" ]; then
	        so=1
	      else
	        so=0	
	      fi
	      fi
	      fi
	      shift 1
	      ;;
	  -h | --help)
	      display_help
	      exit 0
	      ;;
	  --) # End of all options
	      shift
	      break
	      ;;
	  -*)
	      echo "Error: Unknown option: $1" >&2
	      exit 1
	      ;;
	   *) # No more options
	      break
	      ;;
	esac
done

#####################
# Argument warnings #
#####################

### Input file ###
if [ "$input" = "" ]; then
	echo "Input file not found, please specify input file"
	echo "Type $0 -h/--help to see list of commands"
	exit 1
else
	break
fi

### Minimum quality ###
if [ "$minqual" = "" ]; then
	mq=20
	echo "Because you did not define it, minimum quality will be set to 20"
	break
else
	mq=$minqual
	break
fi

### Minimum length ###
if [ "$minlength" = "" ]; then
	ml=100
	echo "Because you did not define it, minimum length will be set to 100"
	break
else
	ml=$minlength
	break
fi

### Sizeout ###
if [ "$so" = "" ]; then
	s="-sizeout"
	echo "Because you did not define it, flag -sizeout will be set to TRUE"
	break
else if [ "$so" = "1" ]; then
	s="-sizeout"
	break
else if [ "$so" = "0" ]; then
	s=""
	break
else
	echo "Error: please set argument -sizeout flag argument can't be understood"
	echo "Type $0 -h/--help to see list of commands"
	exit 1

fi 
fi
fi

#PARAMETER#
#input=Sample_1
#$minqual=20
#minleng=100
#output=$input"_trim"
output=trim

##QUALITY CONTROL##
echo "======================================================="
echo "====================QUALITY CONTROL===================="
echo "======================================================="
echo "Input file:" $input
echo "Minimum quality:" $mq
echo "Minimum length" $ml
echo "Output file:" $output.fastq
echo "-------------------------------------------------------"
fastq_quality_trimmer -t $mq -l $ml -i $input -o $output.fastq
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
usearch -fastx_uniques $input2.fastq -fastaout $output2.fasta $s -relabel Uniq
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
