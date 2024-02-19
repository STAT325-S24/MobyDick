MobyDick
================
Adam Rogers
2024-02-19

This file describes the `MobyDick` data package.

The package loads a tibble with the text of Moby Dick along with line
number, the section of text our line is found, and the chapter number.

The MobyDick package can be installed by running:

    devtools::install_github("STAT325-S24/MobyDick")

``` r
library(MobyDick)
```


    Attaching package: 'MobyDick'

    The following object is masked from 'package:stringr':

        words

``` r
glimpse(MobyDick)
```

    Rows: 22,243
    Columns: 4
    $ text           <chr> "Moby-Dick", "", "or,", "", "THE WHALE.", "", "by Herma…
    $ line_number    <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, …
    $ section        <chr> "title", "title", "title", "title", "title", "title", "…
    $ chapter_number <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0…

This README will soon include some interesting analyses.
