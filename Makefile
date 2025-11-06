.PHONY: all clean install report

# Default target: build everything
all: report

# Install required R packages
install:
	Rscript code/01_load_libraries.R

# Process cleaned data (filter, transform, create variant families)
output/processed_data.rds: code/02_process_data.R data/SARS_Cov_dataset.xlsx
	Rscript code/02_process_data.R

# Generate summary statistics table
output/tables/summary_stats.rds: code/03_make_summary_table.R output/processed_data.rds
	Rscript code/03_make_summary_table.R

# Generate emergence and decline table
output/tables/emergence_decline.rds: code/04_make_emergence_table.R output/processed_data.rds
	Rscript code/04_make_emergence_table.R

# Generate main figure
output/figures/variant_trends.png: code/05_make_figure.R output/processed_data.rds
	Rscript code/05_make_figure.R

# Render final report (flexible - works with any .Rmd filename)
report: output/processed_data.rds \
        output/tables/summary_stats.rds \
        output/tables/emergence_decline.rds \
        output/figures/variant_trends.png
	Rscript code/06_render_report.R

# Clean all generated outputs
clean:
	rm -rf output/*

# Clean and rebuild everything
rebuild: clean all