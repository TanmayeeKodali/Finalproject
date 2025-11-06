# 05_make_figure.R
# Generate main visualization of variant trends

library(tidyverse)

# Load processed data
var_USA <- readRDS("output/processed_data.rds")

# Create the main plot
plot_var <- ggplot(
  var_USA,
  aes(x = week, y = share_pct, color = variant, fill = variant)
) +
  geom_ribbon(aes(ymin = share_lo_pct, ymax = share_hi_pct), 
              alpha = 0.2, color = NA) +
  geom_line(size = 1) +
  labs(
    title = "Trends of Selected SARS-CoV-2 Variants in USA",
    subtitle = "December 2022 - October 2024",
    x = "Week Ending",
    y = "Estimated Proportion (%)",
    color = "Variant",
    fill = "Variant"
  ) +
  theme_bw() +
  theme(
    legend.position = "right",
    plot.title = element_text(size = 14, face = "bold"),
    plot.subtitle = element_text(size = 11),
    axis.title = element_text(size = 11),
    legend.title = element_text(size = 10)
  )

# Display the plot
print(plot_var)

# Create output directory if it doesn't exist
if (!dir.exists("output/figures")) dir.create("output/figures", recursive = TRUE)

# Save the figure in multiple formats
ggsave("output/figures/variant_trends.png", 
       plot = plot_var, 
       width = 10, 
       height = 6, 
       dpi = 300)

ggsave("output/figures/variant_trends.pdf", 
       plot = plot_var, 
       width = 10, 
       height = 6)

cat("Figure saved to:\n")
cat("  - output/figures/variant_trends.png\n")
cat("  - output/figures/variant_trends.pdf\n")