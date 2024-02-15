## code to prepare `DATASET` dataset goes here

library(tidyverse)
library(gutenbergr)

my_mirror <- "http://mirror.csclub.uwaterloo.ca/gutenberg/"
mobydick <- gutenberg_download(15, mirror = my_mirror)

MobyDick <- tibble(mobydick) |>
  select(text) |>
  mutate(line_number = row_number(),
         section = ifelse(row_number() < 10, "title", 
                          ifelse(row_number() < 155, "table_of_contents",
                                 ifelse(row_number() < 197, "etymology",
                                        ifelse(row_number() < 664, "extracts",
                                               "text")))),
         chapter_number = cumsum(str_detect(text, 
                                     regex("^CHAPTER [\\dIVXLC]",
                                           ignore_case = TRUE))))


usethis::use_data(MobyDick, overwrite = TRUE)


