library(tidyverse)
library(optparse)

# Read in arguments for variables (input file)
option_list = list(make_option(c('-f', '--file'), type = 'character', default=NULL, help="Barcode spreadsheet input file", metavar = "character"), 
                   #make_option(c('-l', '--lane'), type = 'character', default='1', help = "Lane of interest for run (usually 1)", metavar = "character"),
                   make_option(c('-o', '--out'), type = 'character', default='barcode_map.txt', help = 'Output file name [default = %default]', metavar = 'character'));
opt_parser = OptionParser(option_list = option_list)
opt = parse_args(opt_parser)

# Basic error handling
if (is.null(opt$file)){
  print_help(opt_parser)
  stop('At least one argument must be supplied (input file).', call. = FALSE)
}

# Define dataframe to manipulate
dm_file <- read.csv(opt$file, sep="")

#dm_file <- read.csv("1_demultiplexing_library_params.txt", sep="")

dm_file <- dm_file %>%
  separate(OUTPUT_PREFIX, into = c(NA,NA,NA,NA,NA,NA,'lane', 'fname'), sep = '/', remove = TRUE) %>%
  filter(BARCODE_1 != 'N') %>%
  add_column(well = c('A01','A10','A11','A12','A02','A03','A04','A05','A06','A07','A08','A09','B01','B10','B11','B12','B02','B03','B04','B05','B06','B07','B08','B09','C01','C10','C11','C12','C02','C03','C04','C05','C06','C07','C08','C09','D01','D10','D11','D12','D02','D03','D04','D05','D06','D07','D08','D09','E01','E10','E11','E12','E02','E03','E04','E05','E06','E07','E08','E09','F01','F10','F11','F12','F02','F03','F04','F05','F06','F07','F08','F09','G01','G10','G11','G12','G02','G03','G04','G05','G06','G07','G08','G09','H01','H10','H11','H12','H02','H03','H04','H05','H06','H07','H08','H09')) %>%
  select(well, lane, fname, BARCODE_1, BARCODE_2)

# Write table to barcode_map.txt
write_delim(dm_file, opt$out, delim = '\t', col_names = FALSE)