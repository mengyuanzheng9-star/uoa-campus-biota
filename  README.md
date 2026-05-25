# The Birds We Notice

Analysis of avian biodiversity and observer behaviour on the University of Auckland City Campus, using iNaturalist citizen science data (2016–2026).

This repository accompanies a Significance-style article examining what iNaturalist bird records reveal about campus birds — and how observer effort shapes what gets recorded.

## Repository contents

- `birds_we_notice.Rmd` — main analysis file: data wrangling, exploratory visualisation, sensitivity analysis, Poisson GLM, and Poisson GLMM
- `birds_we_notice.html` — rendered output of the analysis
- `significance_article.Rmd` — Significance-style article (Rmd source)
- `significance_article.html` — rendered article for submission
- `observations-719197.csv` — raw iNaturalist export (research-grade Aves records, exported 27 April 2026)
- `figure_ranking.png` — most frequently recorded bird groups (used in article)
- `figure_observers.png` — distribution of records across observers (used in article)
- `figure_sensitivity.png` — sensitivity analysis bump chart (used in article)

## How to reproduce the analysis

1. Clone this repository
2. Open `uoa-campus-biota.Rproj` in RStudio
3. Ensure the following R packages are installed:

```r
install.packages(c(
  "tidyverse", "lubridate", "janitor",
  "MASS", "lme4", "broom", "broom.mixed", "DHARMa",
  "patchwork", "ggridges", "viridis",
  "knitr", "kableExtra"
))
```

4. Open `birds_we_notice.Rmd` and click **Knit**
5. Open `significance_article.Rmd` and click **Knit**

The data file `observations-719197.csv` must be in the same folder as the Rmd files. All file paths are relative.

## Analysis overview

The analysis proceeds in four stages:

1. **Data wrangling** — species and subspecies collapsed into broader bird groups; native/introduced status assigned from NZ Birds Online
2. **Observer effort** — distribution of records across 138 contributors; top five observers identified
3. **Sensitivity analysis** — bird group ranking recomputed after removing the five most active observers, to test whether the main pattern is robust to observer identity
4. **Modelling** — Poisson GLM and Poisson GLMM fitted with log-transformed observer count, season, day type, and year as predictors of daily species richness; model selection via AIC and DHARMa diagnostics

## Data source

iNaturalist project: *Biota of University of Auckland City Campus*
https://www.inaturalist.org/projects/biota-of-university-of-auckland-city-campus
Exported: 27 April 2026 | Filter: Research grade, Aves only
