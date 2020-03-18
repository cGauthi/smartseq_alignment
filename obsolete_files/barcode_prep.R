# Rscript to preprocess SmartSeq2 barcode data for downstream alignment
library(tidyverse)
library(readxl)
library(optparse)

# Read in arguments for variables (input file)
option_list = list(make_option(c('-f', '--file'), type = 'character', default=NULL, help="Barcode spreadsheet input file", metavar = "character"), make_option(c('-o', '--out'), type = 'character', default='well_barcode.txt', help = 'Output file name [default = %default]', metavar = 'character'));
opt_parser = OptionParser(option_list = option_list)
opt = parse_args(opt_parser)

# Basic error handling
if (is.null(opt$file)){
  print_help(opt_parser)
  stop('At least one argument must be supplied (input file).', call. = FALSE)
}

# Define dataframe to manipulate
SS_output <- read_xlsx(opt$file, n_max = 96)

#SS_output <- read_xlsx("~/Workbench/alignment_test/Guneykaya (BWH)_SmartSeq2_SK-3X1N_Barcodes_2020.01.14.xlsx", n_max = 96)

# Modify dataframe - extract desired variables, restructure variables, sort alphanumerically
df <- SS_output %>%
  extract(`Well ID`, into = c("Well", "ID"), regex = '._([A-Z])?(\\d+)?', remove = TRUE) %>%
  mutate(ID = as.numeric(ID)) %>%
  arrange_all(.) %>%
  unite(Well_ID, Well, ID, sep='', remove=TRUE) %>%
  select(Well_ID, Barcode)

# Format barcode for downstream processing
df$Barcode <- str_replace(df$Barcode, '-', '_')

# Write table to well_barcode.txt
write_delim(df, opt$out, delim = '\t', col_names = FALSE)
