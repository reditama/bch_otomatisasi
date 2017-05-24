#!/usr/bin/Rscript
library('data.table')
library('getopt')
library('batch')
library('splitstackshape')

os = matrix(c(
  'input', 'i', 2, 'character',
  'tpm_min', 't', 2, 'integer',
  'output', 'o', 2, 'character'
), byrow=TRUE, ncol=4);

options = getopt(os);

input = read.delim(options$input, header = TRUE, row.names = 1)
extract = subset(input, select = c('target_id', 'tpm'))
split = cSplit(extract, 'target_id', sep="|", type.convert = FALSE)
split_extract = subset(split, select = c("target_id_5", "target_id_6", "target_id_7", "tpm"))
split_extract_tpm = split_extract[which(tpm > options$tpm)]

setnames(split_extract_tpm, "target_id_5", "x")
setnames(split_extract_tpm, "target_id_6", "pi")
setnames(split_extract_tpm, "target_id_7", "mw")

write.table(split_extract_tpm, file=options$output, quote = FALSE, sep ="\t", row.names = FALSE)
