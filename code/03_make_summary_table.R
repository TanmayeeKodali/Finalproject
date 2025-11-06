# 03_make_summary_table.R
# Generate summary statistics table for variant prevalence

library(tidyverse)

# Load processed data
var_USA <- readRDS("output/processed_data.rds")

# Calculate summary statistics by variant family
summary_stats <- var_USA |>
  group_by(var_family) |>
  summarize(
    first_week = min(week),
    last_week = max(week),
    mean_prev = round(mean(share_pct), 1),
    peak_prev = round(max(share_pct), 1),
    peak_date = format(week[which.max(share_pct)], "%b %Y"),
    weeks_total = n_distinct(week),
    weeks_dominant = sum(share_pct >= 30)
  ) |>
  arrange(first_week) |>
  mutate(
    period = paste(format(first_week, "%b '%y"), "-", format(last_week, "%b '%y"))
  ) |>
  select(var_family, period, weeks_total, mean_prev, peak_prev, peak_date, weeks_dominant)

# Display summary
cat("Summary Statistics Table:\n")
print(summary_stats)

# Create output directory if it doesn't exist
if (!dir.exists("output/tables")) dir.create("output/tables", recursive = TRUE)

# Save table
saveRDS(summary_stats, "output/tables/summary_stats.rds")
write.csv(summary_stats, "output/tables/summary_stats.csv", row.names = FALSE)

cat("\nSummary table saved to:\n")
cat("  - output/tables/summary_stats.rds\n")
cat("  - output/tables/summary_stats.csv\n")