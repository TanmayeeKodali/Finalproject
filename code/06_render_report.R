# 06_render_report.R
# Render the final report

library(rmarkdown)

# Find the RMD file in report/ directory
rmd_files <- list.files("report", pattern = "\\.Rmd$", full.names = TRUE)

if (length(rmd_files) == 0) {
  stop("No .Rmd file found in report/ directory")
} else if (length(rmd_files) > 1) {
  cat("Multiple .Rmd files found. Using:", rmd_files[1], "\n")
}

rmd_file <- rmd_files[1]
output_name <- gsub("\\.Rmd$", ".pdf", basename(rmd_file))

cat("Rendering:", rmd_file, "\n")
cat("Output will be:", file.path("output", output_name), "\n")

# Render the RMarkdown report to PDF
rmarkdown::render(
  input = rmd_file,
  output_format = "pdf_document",
  output_dir = "output"
)

cat("\nReport rendered successfully!\n")
cat("Output: output/", output_name, "\n", sep = "")