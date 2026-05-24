############################################################
## BIOSCI 738 Week 10 FbF activity
## Project: The Birds We Notice
## Purpose:
## Create one informative visualization to motivate the project.
##
## Main idea:
## iNaturalist bird records are shaped by both birds and people.
## Recorded frequency is not the same as true abundance.
############################################################

## Load packages
library(tidyverse)
library(lubridate)
library(forcats)
library(patchwork)
library(scales)

theme_set(theme_minimal(base_size = 13))
birds_raw <- read_csv("iNaturalist_birds/observations-719197.csv")

glimpse(birds_raw)

birds <- birds_raw %>%
  mutate(
    observed_on = ymd(observed_on),
    year = year(observed_on),
    month = month(observed_on, label = TRUE, abbr = TRUE),
    year_month = floor_date(observed_on, unit = "month"),
    
    bird_group = case_when(
      scientific_name %in% c("Passer domesticus", 
                             "Passer domesticus domesticus") ~ "House Sparrow",
      
      scientific_name %in% c("Columba livia", 
                             "Columba livia domestica") ~ "Rock/Feral Pigeon",
      
      scientific_name %in% c("Turdus merula", 
                             "Turdus merula merula") ~ "Eurasian Blackbird",
      
      scientific_name %in% c("Prosthemadera novaeseelandiae", 
                             "Prosthemadera novaeseelandiae novaeseelandiae") ~ "Tūī",
      
      scientific_name %in% c("Hemiphaga novaeseelandiae", 
                             "Hemiphaga novaeseelandiae novaeseelandiae") ~ "Kererū",
      
      scientific_name %in% c("Rhipidura fuliginosa", 
                             "Rhipidura fuliginosa placabilis") ~ "New Zealand Fantail",
      
      scientific_name %in% c("Zosterops lateralis", 
                             "Zosterops lateralis lateralis") ~ "Silvereye",
      
      scientific_name %in% c("Todiramphus sanctus", 
                             "Todiramphus sanctus vagans") ~ "Sacred Kingfisher",
      
      scientific_name %in% c("Carduelis carduelis", 
                             "Carduelis carduelis britannica") ~ "European Goldfinch",
      
      scientific_name %in% c("Hirundo neoxena", 
                             "Hirundo neoxena neoxena") ~ "Welcome Swallow",
      
      scientific_name %in% c("Sturnus vulgaris", 
                             "Sturnus vulgaris vulgaris") ~ "Common Starling",
      
      scientific_name == "Platycercus eximius" ~ "Eastern Rosella",
      scientific_name == "Platycercus eximius eximius" ~ "Eastern Rosella",
      scientific_name == "Gymnorhina tibicen" ~ "Australian Magpie",
      scientific_name == "Acridotheres tristis" ~ "Common Myna",
      scientific_name == "Turdus philomelos" ~ "Song Thrush",
      scientific_name == "Fringilla coelebs gengleri" ~ "Chaffinch",
      scientific_name == "Gerygone igata" ~ "Riroriro / Grey Warbler",
      
      TRUE ~ coalesce(common_name, species_guess, scientific_name)
    )
  )

## Make sure dates are treated as dates.
birds <- birds %>%
  mutate(
    observed_on = as.Date(observed_on),
    year = year(observed_on),
    month = month(observed_on, label = TRUE, abbr = TRUE)
  )


## ---------------------------------------------------------
## 3. Key summary numbers
## ---------------------------------------------------------

n_observations <- nrow(birds)
n_observers <- n_distinct(birds$user_login)
n_bird_groups <- n_distinct(birds$bird_group)


## Identify the top five observers.
top5_observers <- birds %>%
  count(user_login, sort = TRUE) %>%
  slice_head(n = 5)

top5_observer_names <- top5_observers$user_login

top5_n <- sum(top5_observers$n)
top5_percent <- top5_n / n_observations


## ---------------------------------------------------------
## 4. Panel A: Most frequently recorded bird groups
## ---------------------------------------------------------
## This panel shows the raw recorded bird ranking.
## It motivates the first question:
## Are these the most abundant birds, or simply the birds
## most often noticed and recorded?

top_birds <- birds %>%
  count(bird_group, sort = TRUE) %>%
  slice_head(n = 10) %>%
  mutate(
    bird_group = fct_reorder(bird_group, n)
  )

p1 <- ggplot(top_birds, aes(x = n, y = bird_group)) +
  geom_col(fill = "#4E79A7") +
  labs(
    title = "A. The birds most often recorded",
    subtitle = paste0(
      n_observations, " research-grade observations across ",
      n_bird_groups, " cleaned bird groups"
    ),
    x = "Number of observations",
    y = NULL
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold"),
    panel.grid.major.y = element_blank()
  )


## ---------------------------------------------------------
## 5. Panel B: Observer contribution
## ---------------------------------------------------------
## This panel shows uneven observer effort.
## It motivates the second question:
## How much do people shape the iNaturalist dataset?

observer_counts <- birds %>%
  count(user_login, sort = TRUE) %>%
  mutate(
    observer_rank = row_number(),
    observer_type = if_else(
      user_login %in% top5_observer_names,
      "Top five observers",
      "Other observers"
    )
  )

p2 <- ggplot(observer_counts, aes(x = observer_rank, y = n)) +
  geom_col(aes(fill = observer_type), width = 0.85) +
  scale_fill_manual(
    values = c(
      "Top five observers" = "#00A6A6",
      "Other observers" = "#F4A261"
    )
  ) +
  annotate(
    "text",
    x = max(observer_counts$observer_rank) * 0.48,
    y = max(observer_counts$n) * 0.92,
    label = paste0(
      "Top 5 observers contributed\n",
      top5_n, " records (", percent(top5_percent, accuracy = 0.1), ")"
    ),
    hjust = 0,
    vjust = 1,
    size = 3.8
  ) +
  labs(
    title = "B. The records were not evenly contributed",
    subtitle = paste0(n_observers, " observers contributed to the dataset"),
    x = "Observer rank",
    y = "Number of observations"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    legend.position = "none",
    plot.title = element_text(face = "bold")
  )


## ---------------------------------------------------------
## 6. Panel C: Sensitivity analysis
## ---------------------------------------------------------
## This panel compares bird-group counts before and after
## removing the top five observers.
##
## Instead of using side-by-side bars, this version uses
## an overlay style:
## - light grey = all records
## - dark grey = top five observers removed
##
## This makes the reduction easier to see.

ranking_all <- birds %>%
  count(bird_group, sort = TRUE) %>%
  mutate(
    rank_all = row_number()
  )

birds_without_top5 <- birds %>%
  filter(!user_login %in% top5_observer_names)

ranking_without_top5 <- birds_without_top5 %>%
  count(bird_group, sort = TRUE) %>%
  mutate(
    rank_without_top5 = row_number()
  )

ranking_comparison <- full_join(
  ranking_all %>%
    dplyr::select(bird_group, n_all = n, rank_all),
  ranking_without_top5 %>%
    dplyr::select(bird_group, n_without_top5 = n, rank_without_top5),
  by = "bird_group"
) %>%
  mutate(
    n_without_top5 = replace_na(n_without_top5, 0L),
    records_from_top5 = n_all - n_without_top5,
    prop_from_top5 = records_from_top5 / n_all
  ) %>%
  arrange(rank_all)


## Keep the top 10 bird groups from the full dataset.
## This keeps the figure readable for peer feedback.
ranking_plot_data <- ranking_comparison %>%
  slice_head(n = 10) %>%
  mutate(
    bird_group = fct_reorder(bird_group, n_all)
  )

p3 <- ggplot(ranking_plot_data, aes(y = bird_group)) +
  geom_col(
    aes(x = n_all, fill = "All records"),
    width = 0.72
  ) +
  geom_col(
    aes(x = n_without_top5, fill = "After removing top 5"),
    width = 0.42
  ) +
  scale_fill_manual(
    values = c(
      "All records" = "#F6C28B",
      "After removing top 5" = "#00A6A6"
    )
  ) +
  labs(
    title = "C. What changes if the top five observers are removed?",
    subtitle = "Top-ranked groups stay similar; lower-count groups shift more",
    x = "Number of observations",
    y = NULL,
    fill = NULL
  ) +
  theme_minimal(base_size = 12) +
  theme(
    legend.position = "bottom",
    plot.title = element_text(face = "bold"),
    panel.grid.major.y = element_blank()
  )


## ---------------------------------------------------------
## 7. Combine panels into one project-motivation figure
## ---------------------------------------------------------
## The layout:
## Panel A and B are on the top row.
## Panel C is wider and placed on the bottom row.
##
## This structure tells the project story:
## First, we see the bird ranking.
## Then, we see uneven observer effort.
## Finally, we test whether active observers affect the pattern.

combined_figure <- (p1 | p2) / p3 +
  plot_layout(heights = c(1, 1.15)) +
  plot_annotation(
    title = "The Birds We Notice",
    subtitle = "Campus bird records reflect both birds and the people who notice them",
    caption = "Data: research-grade bird observations from the University of Auckland City Campus iNaturalist project.",
    theme = theme(
      plot.title = element_text(size = 22, face = "bold"),
      plot.subtitle = element_text(size = 14),
      plot.caption = element_text(size = 10)
    )
  )

combined_figure


## ---------------------------------------------------------
## 8. Save figure
## ---------------------------------------------------------
## Save as both PNG and PDF.
## Use the PNG in Word / Google Docs.
## The PDF is useful if you want a sharper version.

ggsave(
  filename = "the_birds_we_notice_fbf_visualization.png",
  plot = combined_figure,
  width = 12,
  height = 9,
  dpi = 300
)

ggsave(
  filename = "the_birds_we_notice_fbf_visualization.pdf",
  plot = combined_figure,
  width = 12,
  height = 9
)