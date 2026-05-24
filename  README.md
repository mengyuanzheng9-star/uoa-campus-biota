# The Birds We Notice

Analysis of avian biodiversity and observer behaviour on the 
University of Auckland City Campus, using iNaturalist citizen 
science data (2016–2026).

## Repository contents

- `birds_we_notice.Rmd` — main analysis file (data wrangling, 
  visualisation, Poisson GLM modelling)
- `observations-719197.csv` — raw iNaturalist export (research-grade 
  Aves records, exported 27 April 2026)
- `significance_article.Rmd` — Significance-style article (knit to produce significance_article.html)
- `figure1.png` — Species frequency plot
- `figure2.png` — GLM coefficient plot

## How to reproduce the analysis

1. Clone this repository
2. Open `uoa-campus-biota.Rproj` in RStudio
3. Ensure the following R packages are installed:
   `tidyverse`, `lubridate`, `janitor`, `MASS`, `broom`, 
   `DHARMa`, `patchwork`, `ggridges`, `viridis`, `knitr`, 
   `kableExtra`
4. Open `birds_we_notice.Rmd` and click Knit

The data file `observations-719197.csv` must be in the same 
folder as the Rmd file. All file paths are relative.

## Data source

iNaturalist project: *Biota of University of Auckland City Campus*  
https://www.inaturalist.org/projects/biota-of-university-of-auckland-city-campus  
Exported: 27 April 2026 | Filter: Research grade, Aves only