# 04_make_emergence_table.R
# Generate emergence and decline dynamics table

library(tidyverse)

# Load processed data
var_USA <- readRDS("output/processed_data.rds")

# Calculate emergence and decline metrics
emergence_decline <- var_USA |>
  group_by(var_family) |>
  arrange(week) |>
  summarize(
    first_detect = min(week),
    peak_week = week[which.max(share_pct)],
    last_detect = max(week),
    peak_prev = round(max(share_pct), 1),
    weeks_to_peak = as.numeric(difftime(week[which.max(share_pct)], min(week), units = "weeks")),
    weeks_decline = as.numeric(difftime(max(week), week[which.max(share_pct)], units = "weeks")),
    emergence_rate = round(peak_prev / (weeks_to_peak + 1), 2),  # % per week
    decline_rate = round(peak_prev / (weeks_decline + 1), 2)      # % per week
  ) |>
  arrange(first_detect)

# Display table
cat("Emergence and Decline Dynamics Table:\n")
print(emergence_decline)

# Calculate overlap statistics
overlap_analysis <- var_USA |>
  group_by(week) |>
  summarize(
    n_variants = n_distinct(variant[share_pct >= 5]),
    total_prev = sum(share_pct[share_pct >= 5]),
    variants_list = paste(variant[share_pct >= 5], collapse = ", ")
  ) |>
  filter(n_variants > 0)

cat("\n\nOverlap Analysis:\n")
cat("Weeks with multiple variants >5%:", sum(overlap_analysis$n_variants > 1), "\n")
cat("Maximum concurrent variants:", max(overlap_analysis$n_variants), "\n")

# Create output directory if it doesn't exist
if (!dir.exists("output/tables")) dir.create("output/tables", recursive = TRUE)

# Save tables
saveRDS(emergence_decline, "output/tables/emergence_decline.rds")
write.csv(emergence_decline, "output/tables/emergence_decline.csv", row.names = FALSE)

saveRDS(overlap_analysis, "output/tables/overlap_analysis.rds")

cat("\nEmergence/decline table saved to:\n")
cat("  - output/tables/emergence_decline.rds\n")
cat("  - output/tables/emergence_decline.csv\n")
cat("  - output/tables/overlap_analysis.rds\n")