# The Birds We Notice

Analysis of avian biodiversity and observer behaviour on the University of Auckland City Campus, using iNaturalist citizen science data (2016–2026).

This repository accompanies a Significance-style article examining what iNaturalist bird records reveal about campus birds, and how observer effort shapes what gets recorded.

## Quick start

The final submitted article is:

- `significance_article_magazine.html` — a self-contained, magazine-style article (all figures are embedded, so it displays correctly on its own)

The full analysis code is:

- `birds_we_notice.Rmd`

The analysis file imports the raw iNaturalist data, cleans the bird records, performs the observer-effort analysis, fits the GLM and GLMM models, and produces the figures used in the article.

Please download or clone the full repository rather than individual files, because `birds_we_notice.Rmd` relies on the raw CSV stored in this repository.

## Repository contents

- `birds_we_notice.Rmd` — main analysis file: data wrangling, exploratory visualisation, sensitivity analysis, Poisson GLM, Poisson GLMM, diagnostics, and figure generation
- `birds_we_notice.html` — rendered output of the analysis
- `significance_article_magazine.html` — final Significance-style article for submission (figures embedded; opens correctly as a standalone file)
- `observations-719197.csv` — raw iNaturalist export, research-grade Aves records, exported 27 April 2026
- `figure/` — the three figures used in the article:
  - `figure/figure_ranking.png` — most frequently recorded bird groups
  - `figure/figure_observers.png` — distribution of records across observers
  - `figure/figure_sensitivity.png` — sensitivity analysis bump chart
  - `figure/cover.png` — header image used in the article
- `uoa-campus-biota.Rproj` — RStudio project file for setting the working directory correctly

## How to reproduce the analysis

1. Clone or download the full repository.
2. Open `uoa-campus-biota.Rproj` in RStudio.
3. Ensure the following R packages are installed:

```r
install.packages(c(
  "tidyverse", "lubridate", "janitor",
  "MASS", "lme4", "broom", "broom.mixed", "DHARMa",
  "patchwork", "ggridges", "viridis",
  "knitr", "kableExtra","vegan"
))
```

4. Knit `birds_we_notice.Rmd` to reproduce the full analysis, including all figures and model output.

The raw data file `observations-719197.csv` must remain in the main repository folder. All file paths are relative to the RStudio project folder.

## Analysis overview

The analysis proceeds in four stages:

1. **Data wrangling** — species and subspecies are collapsed into broader bird groups; native/introduced status is assigned using NZ Birds Online.
2. **Observer effort** — the distribution of records across 138 contributors is examined, and the five most active observers are identified.
3. **Sensitivity analysis** — the bird group ranking is recomputed after removing the five most active observers, to test whether the main leaderboard is robust to observer identity.
4. **Modelling** — Poisson GLM and Poisson GLMM models are fitted with log-transformed observer count, season, day type, and year as predictors of daily bird-group richness. Model choice and diagnostics are checked using AIC and DHARMa.

## Data source

iNaturalist project: *Biota of University of Auckland City Campus*
[https://www.inaturalist.org/projects/biota-of-university-of-auckland-city-campus](https://www.inaturalist.org/projects/biota-of-university-of-auckland-city-campus)

Exported: 27 April 2026
Filter: Research grade, Aves only