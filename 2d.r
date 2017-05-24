#!/usr/bin/Rscript
library('getopt')
library('batch')
library('ggplot2')

os = matrix(c(
  'input', 'i', 2, 'character',
  'resolution', 'r', 2, 'character',
  'base', 'b', 2, 'integer',
  'log', 'l', 2, 'character',
  'ladder', 'm', 2, 'character',
  'output', 'o', 2, 'character'
), byrow=TRUE, ncol=4);

options = getopt(os);

input = read.delim(options$input, header = TRUE, row.names = 1)
ladder = read.delim("/home/bioinformatics3/galaxy-bakf2/tools/2d/ladder_smart", header = TRUE, row.names = 1)

if (options$ladder == "y"){
table = rbind(ladder,input)
fill = c("black", "red", "blue", "yellow", "green", "blue","magenta", "violet")
}else if (options$ladder == "n"){
table = rbind(input)
fill = c("red", "orange", "yellow", "green", "blue","magenta", "violet")
}

if (options$resolution == "s"){
   png(options$output, width = 480, height = 480, unit = "px")
}else if (options$resolution == "m"){
   png(options$output, width = 720, height = 720, unit = "px")
}else if (options$resolution == "l"){
   png(options$output, width = 1024, height = 1024, unit = "px")
}

basevalue = options$base


{if (options$log == "y"){
ggplot(table, aes(x = pi, y = log(mw, base = basevalue), size = tpm*mw))
}else if (options$log == "n"){
ggplot(table, aes(x = pi, y = mw, size = tpm*mw))
}
} + geom_point (shape = 20) + theme (legend.position = "bottom", legend.direction= "horizontal") + scale_fill_manual(values = fill) + labs(x = "Isoelectric point", y = "log(Molecular Weight)", size = "Expression", fill = "Group")
