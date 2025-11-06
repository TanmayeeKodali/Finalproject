# 02_process_data.R
# Process and clean SARS-CoV-2 variant data
# Input: Cleaned CDC data (173k rows, all variants and time periods)

library(tidyverse)
library(labelled)
library(readxl)

# Load cleaned dataset
covid_var <- readxl::read_excel("data/SARS_Cov_dataset.xlsx")

cat("Loaded dataset:", nrow(covid_var), "rows,", ncol(covid_var), "columns\n")

# Define variants of interest (dominant post-2022 lineages)
chosen_var <- c("XBB.1.5", "XBB.1.16", "EG.5", "HV.1", "JN.1",
                "KP.2", "KP.3", "KP.3.1.1")

# Filter and process data
var_USA <- covid_var |>
  mutate(week = as.Date(week_ending)) |>
  filter(
    usa_or_hhsregion == "USA",
    variant %in% chosen_var,
    week >= as.Date("2022-12-01"),
    week <= as.Date("2024-10-31"),
    share >= 0.001  # 0.001 = 0.1%
  ) |>
  select(week, variant, share, share_lo, share_hi) |>
  arrange(week, variant) |>
  # Convert share to percentage for display
  mutate(
    share_pct = share * 100,
    share_lo_pct = share_lo * 100,
    share_hi_pct = share_hi * 100
  )

# Create variant family groups
var_USA <- var_USA |>
  mutate(var_family = case_when(
    variant %in% c("XBB.1.5", "XBB.1.16") ~ "XBB Lineages",
    variant == "EG.5" ~ "EG.5",
    variant == "HV.1" ~ "HV.1",
    variant == "JN.1" ~ "JN.1",
    variant %in% c("KP.2", "KP.3", "KP.3.1.1") ~ "FLiRT (KP.*)",
    TRUE ~ variant
  ))

# Add labels for better documentation
var_label(var_USA) <- list(
  week = "Week Ending",
  variant = "Variant Lineage",
  var_family = "Variant Family",
  share_pct = "Proportion (%)"
)

# Display processing summary
cat("\nProcessed dataset:", nrow(var_USA), "rows\n")
cat("Reduction: from", nrow(covid_var), "to", nrow(var_USA), "rows\n")
cat("Time range:", as.character(min(var_USA$week)), "to", as.character(max(var_USA$week)), "\n")
cat("Number of unique variants:", n_distinct(var_USA$variant), "\n")
cat("Variant families:", paste(unique(var_USA$var_family), collapse = ", "), "\n")

# Create output directory if it doesn't exist
if (!dir.exists("output")) dir.create("output")

# Save processed data
saveRDS(var_USA, "output/processed_data.rds")
cat("\nProcessed data saved to: output/processed_data.rds\n")