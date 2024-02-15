## code to prepare `DATASET` dataset goes here

library(tidyverse)
library(gutenbergr)

my_mirror <- "http://mirror.csclub.uwaterloo.ca/gutenberg/"
mobydick <- gutenberg_download(15, mirror = my_mirror)

MobyDick <- tibble(mobydick) |>
  select(text)

usethis::use_data(MobyDick, overwrite = TRUE)


