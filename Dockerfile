FROM rocker/tidyverse:4.3.0

# Install system dependencies
RUN apt-get update && apt-get install -y \
    pandoc \
    pandoc-citeproc \
    texlive-latex-base \
    texlive-latex-extra \
    texlive-fonts-recommended \
    && rm -rf /var/lib/apt/lists/*

# Install required R packages
RUN R -e "install.packages(c('gtsummary', 'kableExtra', 'labelled', 'scales', 'plotly', 'readxl', 'rmarkdown', 'knitr'), repos='https://cloud.r-project.org/')"

# Set working directory
WORKDIR /project

# Copy project files
COPY data/ /project/data/
COPY code/ /project/code/
COPY report/ /project/report/

# Create output directory structure
RUN mkdir -p /project/output/tables /project/output/figures

# Set output directory as mountable volume
VOLUME ["/project/output"]

# Run the complete pipeline
CMD set -e && \
    Rscript code/02_process_data.R && \
    Rscript code/03_make_summary_table.R && \
    Rscript code/04_make_emergence_table.R && \
    Rscript code/05_make_figure.R && \
    Rscript code/06_render_report.R && \
    echo "✓ Report generation complete!"