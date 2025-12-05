# SARS-CoV-2 Variant Dominance Analysis: Post-2022 Trends

## Project Description

This project analyzes the temporal patterns of SARS-CoV-2 variant emergence and dominance in the United States from December 2022 through October 2024. The analysis focuses on eight major variants that achieved significant prevalence (>5%), examining their emergence rates, peak prevalence, and replacement dynamics.

**Key findings:**
- XBB lineages and JN.1 achieved the highest dominance (90-93% prevalence)
- Variants showed rapid emergence (1-6% per week) and sequential replacement
- Minimal overlap between dominant strains, indicating strong selective advantages

---

## Docker Container

This project includes a Docker container for fully reproducible analysis. The container includes all required dependencies and generates the complete report.

### Docker Image on DockerHub

The Docker image is publicly available on DockerHub:

**Image:** `tanmayeekodali/covid-analysis:latest`

**DockerHub Link:** https://hub.docker.com/r/tanmayeekodali/covid-analysis

### Building the Docker Image

If you want to build the image locally (optional, since it's available on DockerHub):

```bash
# From the project root directory
docker build -t tanmayeekodali/covid-analysis:latest .
```

This will:
- Install R and all required packages
- Copy all project files (data, code, report)
- Set up the complete analysis pipeline

### Running the Docker Container

#### Using Make (Recommended - Cross-Platform)

The easiest way to generate the report using Docker:

```bash
make docker-run
```

This command will:
1. Pull the Docker image from DockerHub (if not already local)
2. Create an empty `report/` directory in your project
3. Run the container and mount the `report/` directory
4. Execute the complete analysis pipeline
5. Save the generated report files to `report/`

**Output files** (in the `report/` directory):
- `Finalproject.pdf` - PDF version of the report
- `Finalproject.html` - HTML version of the report
- `processed_data.rds` - Processed dataset
- `tables/` - Summary statistics and emergence/decline tables
- `figures/` - Variant trends visualization

#### Manual Docker Run

If you prefer to run Docker directly:

**On Mac/Linux:**
```bash
# Create empty report directory
mkdir -p report

# Run the container
docker run --rm \
  -v "$(pwd)/report:/project/output" \
  tanmayeekodali/covid-analysis:latest
```

**On Windows (Git Bash):**
```bash
# Create empty report directory
mkdir -p report

# Run the container
docker run --rm \
  -v "/$(pwd)/report:/project/output" \
  tanmayeekodali/covid-analysis:latest
```

**Note for Windows users:** The extra `/` before `$(pwd)` is required for Git Bash to correctly interpret the path for volume mounting.

---

## Repository Structure

```
.
├── README.md                    # This file
├── Dockerfile                   # Docker configuration
├── Makefile                     # Build automation
├── renv.lock                    # Package dependency snapshot (renv)
├── .Rprofile                    # renv activation script
├── renv/                        # renv package library
├── data/
│   └── SARS_Cov_dataset.xlsx    # Cleaned dataset (173,130 rows, 10 columns)
├── code/
│   ├── 01_load_libraries.R      # Install/load required packages
│   ├── 02_process_data.R        # Data filtering and transformation
│   ├── 03_make_summary_table.R  # Generate summary statistics (REQUIRED TABLE)
│   ├── 04_make_emergence_table.R # Generate emergence/decline metrics
│   ├── 05_make_figure.R         # Create variant trends plot (REQUIRED FIGURE)
│   └── 06_render_report.R       # Render final PDF report
├── report/
│   └── Finalproject.Rmd        # Main analysis report
├── output/                      # Generated files (local builds)
│   ├── processed_data.rds       # Processed dataset (4,254 rows)
│   ├── tables/
│   │   ├── summary_stats.rds    # Summary statistics table
│   │   └── emergence_decline.rds # Emergence/decline table
│   ├── figures/
│   │   └── variant_trends.png   # Main visualization
│   ├── Finalproject.pdf         # Final report (generated)
│   └── Finalproject.html        # Final report (generated)
└── report/                      # Docker-generated output directory
    └── (same structure as output/)
```

---

## Data Source

- **Original data:** CDC's SARS-CoV-2 Variant Proportions dataset
  - URL: https://data.cdc.gov/Laboratory-Surveillance/SARS-CoV-2-Variant-Proportions/jr58-6ysp
  - Original size: ~4 million rows (too large for GitHub)
  - Cleaned data in repository: 173,130 rows, 10 columns
  - Final analysis dataset: 4,254 rows (after filtering for specific variants, dates, and thresholds)

**Note:** The dataset in `data/` is a reduced Excel file (SARS_Cov_dataset.xlsx) containing a subset of the original CDC data but with all variants and time periods needed for the analysis. The `02_process_data.R` script filters this down to the 8 specific variants of interest for the Dec 2022 - Oct 2024 period, reducing from 173,130 rows to approximately 4,254 rows.

---

## Prerequisites

### For Local Builds

#### System Requirements
- R (version ≥ 4.0)
- RStudio (optional, for interactive use)
- Make (for using Makefile; typically pre-installed on Mac/Linux)

#### Required R Packages
This project uses **renv** for package management. All required packages and their versions are specified in `renv.lock`.

### For Docker Builds

#### System Requirements
- Docker Desktop (Mac/Windows) or Docker Engine (Linux)
  - Download: https://www.docker.com/get-started

That's it! All R dependencies are included in the Docker image.

---

## Reproducibility: Package Management with renv

### Synchronizing the package environment

After cloning this repository, restore the package environment:

```bash
make install
```

This will install all required packages with the versions specified in `renv.lock`.

---

## Generating the Report

### Method 1: Using Docker (Fully Reproducible)

**Recommended for maximum reproducibility.** This method ensures identical results across all systems.

```bash
# Generate report using the pre-built Docker image
make docker-run
```

The report will be created in the `report/` directory.

### Method 2: Local Build

#### Full Build (Recommended)

This will run all analysis steps and generate the final report:

```bash
# First time: Install required packages
make install

# Build everything
make all
```

#### Step-by-Step Build

You can also run individual steps:

```bash
# Process the data
Rscript code/02_process_data.R

# Generate tables
Rscript code/03_make_summary_table.R
Rscript code/04_make_emergence_table.R

# Generate figure
Rscript code/05_make_figure.R

# Render report
Rscript code/06_render_report.R
```

#### Clean and Rebuild

To remove all generated files and rebuild from scratch:

```bash
make rebuild
```

---

## Makefile Targets

### Local Build Targets
- `make install` - Install required R packages using renv
- `make all` or `make report` - Build the complete analysis and report (default)
- `make clean` - Remove all generated outputs
- `make rebuild` - Clean and rebuild everything from scratch

### Docker Targets
- `make docker-run` - Run the Docker container to generate the report in `report/` directory

---

## Key Outputs

### Required Table: Summary Statistics
- **Location:** `code/03_make_summary_table.R`
- **Output:** `output/tables/summary_stats.rds` (or `report/tables/summary_stats.rds` from Docker)
- **Description:** Summary statistics table showing:
  - Time period of circulation
  - Mean and peak prevalence percentages
  - Number of weeks with >30% dominance
  - Peak occurrence dates

### Required Figure: Variant Trends
- **Location:** `code/05_make_figure.R`
- **Output:** `output/figures/variant_trends.png` (or `report/figures/variant_trends.png` from Docker)
- **Description:** Time series visualization showing:
  - Variant prevalence over time (Dec 2022 - Oct 2024)
  - Confidence intervals (shaded regions)
  - Sequential replacement patterns
  - All 8 analyzed variants

### Additional Output: Emergence/Decline Dynamics
- **Location:** `code/04_make_emergence_table.R`
- **Output:** `output/tables/emergence_decline.rds` (or `report/tables/emergence_decline.rds` from Docker)
- **Description:** Metrics for variant emergence and decline rates

---

## Analysis Details

### Variants Analyzed
1. **XBB Lineages:** XBB.1.5, XBB.1.16
2. **EG.5**
3. **HV.1**
4. **JN.1**
5. **FLiRT variants (KP.*):** KP.2, KP.3, KP.3.1.1

### Key Findings

**Dominant Variants:**
- XBB lineages: 90.2% peak prevalence (March 2023)
- JN.1: 96.4% peak prevalence (February 2024)

**Emergence Rates:**
- Fastest: XBB lineages (5.64%/week)
- Slowest: EG.5 (1.18%/week)

**Replacement Dynamics:**
- Clean sequential replacement with minimal overlap
- Maximum 4 concurrent variants >5% at any given time
- Only 38 weeks showed multiple variants >5%

---

## Troubleshooting

### Common Issues

**Issue:** `make: command not found`
- **Solution:** Install Make or run R scripts directly using `Rscript code/XX_*.R`, or use Docker method

**Issue:** Package installation fails during `renv::restore()`
- **Solution:** Ensure you have a stable internet connection. Try running `make install` again.

**Issue:** "cannot open file 'data/SARS_Cov_dataset.xlsx'"
- **Solution:** Ensure the cleaned Excel file is in the `data/` directory with the exact filename `SARS_Cov_dataset.xlsx`

**Issue:** PDF rendering fails
- **Solution:** Install a LaTeX distribution (TinyTeX recommended: `tinytex::install_tinytex()`) or use the Docker method

**Issue:** Docker volume mounting fails on Windows
- **Solution:** Ensure you're using Git Bash and the path includes the extra `/` prefix, or use `make docker-run` which handles this automatically

**Issue:** Docker image pull fails
- **Solution:** Check your internet connection and verify the image exists at https://hub.docker.com/r/tanmayeekodali/covid-analysis

---

## Contact

**Author:** Tanmayee Kodali  
**Course:** DATA 550 - Data Science Toolkit  
**Institution:** Emory University

For questions or issues, please open an issue on this GitHub repository.

---

## License

This project is for educational purposes as part of DATA 550 coursework.