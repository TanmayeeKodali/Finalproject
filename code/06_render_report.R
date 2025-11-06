# 06_render_report.R
# Render the final report in both PDF and HTML formats

library(rmarkdown)

# Find the RMD file in report/ directory
rmd_files <- list.files("report", pattern = "\\.Rmd$", full.names = TRUE)

if (length(rmd_files) == 0) {
  stop("No .Rmd file found in report/ directory")
} else if (length(rmd_files) > 1) {
  cat("Multiple .Rmd files found. Using:", rmd_files[1], "\n")
}

rmd_file <- rmd_files[1]
base_name <- gsub("\\.Rmd$", "", basename(rmd_file))

cat("Rendering:", rmd_file, "\n")

# Render PDF version
cat("\n=== Rendering PDF ===\n")
rmarkdown::render(
  input = rmd_file,
  output_format = "pdf_document",
  output_dir = "output"
)
cat("PDF created: output/", base_name, ".pdf\n", sep = "")

# Render HTML version
cat("\n=== Rendering HTML ===\n")
rmarkdown::render(
  input = rmd_file,
  output_format = "html_document",
  output_dir = "output"
)
cat("HTML created: output/", base_name, ".html\n", sep = "")

cat("\n✓ Both reports rendered successfully!\n")
cat("Outputs:\n")
cat("  - output/", base_name, ".pdf\n", sep = "")
cat("  - output/", base_name, ".html\n", sep = "")