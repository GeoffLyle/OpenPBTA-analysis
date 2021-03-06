FROM rocker/tidyverse:3.6.0
MAINTAINER ccdl@alexslemonade.org
WORKDIR /rocker-build/

RUN apt-get update && apt-get install -y --no-install-recommends apt-utils

RUN apt-get install dialog apt-utils -y

# Required for installing mapview for interactive sample distribution plots
# libmagick++-dev is needed for coloblindr to install
RUN apt-get update -qq && apt-get -y --no-install-recommends install \
    libgdal-dev \
    libudunits2-dev \
    libmagick++-dev

# Required forinteractive sample distribution plots
# map view is needed to create HTML outputs of the interactive plots
RUN apt-get update -qq && apt-get -y --no-install-recommends install \
    && install2.r --error \
    --deps TRUE \
    gdalUtils \
    leafem \
    lwgeom \
    stars \
    leafpop \
    plainview \
    sf \
    mapview

# Installs packages needed for still treemap, interactive plots, and hex plots
# Rtsne and umap are required for dimension reduction analyses
# optparse is needed for passing arguments from the command line to R script
RUN apt-get update -qq && apt-get -y --no-install-recommends install \
    && install2.r --error \
    --deps TRUE \
    R.utils \
    treemap \
    d3r \
    hexbin \
    VennDiagram \
    Rtsne \
    umap \
    rprojroot \
    optparse \
    pheatmap \
    RColorBrewer \
    viridis \
    data.table

# maftools for proof of concept in create-subset-files
RUN R -e "BiocManager::install(c('maftools'), update = FALSE)"

# This is needed for the CNV frequency and proportion aberration plots
RUN R -e "BiocManager::install(c('GenVisR'), update = FALSE)"

# These packages are for the genomic region analysis for snv-callers
RUN R -e "BiocManager::install(c('annotatr', 'TxDb.Hsapiens.UCSC.hg38.knownGene', 'org.Hs.eg.db'), update = FALSE)"

# Packages for expression normalization and batch correction
RUN R -e "BiocManager::install(c('preprocessCore', 'sva'), update = FALSE)"


## This is deprecated
#  # These packages are for single-sample GSEA analysis
#  RUN R -e "BiocManager::install(c('GSEABase', 'GSVA'), update = FALSE)"


# This is needed to create the interactive pie chart
RUN R -e "devtools::install_github('timelyportfolio/sunburstR', ref = 'd40d7ed71ee87ca4fbb9cb8b7cf1e198a23605a9', dependencies = TRUE)"

# This is needed to create the interactive treemap
RUN R -e "devtools::install_github('timelyportfolio/d3treeR', ref = '0eaba7f1c6438e977f8a5c082f1474408ac1fd80', dependencies = TRUE)"

# Need this package to make plots colorblind friendly
RUN R -e "devtools::install_github('clauswilke/colorblindr', ref = '1ac3d4d62dad047b68bb66c06cee927a4517d678', dependencies = TRUE)"

# Required for sex prediction from RNA-seq data
RUN apt-get update -qq && apt-get -y --no-install-recommends install \
    && install2.r --error \
    --deps TRUE \
    glmnet \
    glmnetUtils \
    caret \
    e1071

# Install java and rJava for some of the snv plotting comparison packages
RUN apt-get -y update && apt-get install -y \
   default-jdk \
   r-cran-rjava \
   && apt-get clean \
   && rm -rf /var/lib/apt/lists/

# Install for SNV comparison plots
RUN apt-get update -qq && apt-get -y --no-install-recommends install \
    && install2.r --error \
    --deps TRUE \
    UpSetR

RUN R -e "devtools::install_github('const-ae/ggupset', ref = '7a33263cc5fafdd72a5bfcbebe5185fafe050c73', dependencies = TRUE)"

# GGally and its required packages
RUN apt-get update -qq && apt-get -y --no-install-recommends install \
    && install2.r --error \
    lattice \
    rpart \
    class \
    MASS \
    GGally \
    Matrix

# Help display tables in R Notebooks
RUN apt-get update -qq && apt-get -y --no-install-recommends install \
    && install2.r --error \
    flextable

# Required for mapping segments to genes
# Add bedtools
RUN wget https://github.com/arq5x/bedtools2/releases/download/v2.28.0/bedtools-2.28.0.tar.gz
RUN tar -zxvf bedtools-2.28.0.tar.gz
RUN cd bedtools2 && \
    make && \
    mv bin/* /usr/local/bin

# Required for installing htslib
RUN apt-get update -qq && apt-get -y --no-install-recommends install \
    zlib1g \
    libbz2-dev \
    liblzma-dev

# Add bedops per the BEDOPS documentation
RUN wget https://github.com/bedops/bedops/releases/download/v2.4.37/bedops_linux_x86_64-v2.4.37.tar.bz2
RUN tar -jxvf bedops_linux_x86_64-v2.4.37.tar.bz2 && rm -f bedops_linux_x86_64-v2.4.37.tar.bz2
RUN cp bin/* /usr/local/bin

# HTSlib
RUN wget https://github.com/samtools/htslib/releases/download/1.9/htslib-1.9.tar.bz2
RUN tar -jxvf htslib-1.9.tar.bz2 && rm -f htslib-1.9.tar.bz2
RUN cd htslib-1.9 && \
    ./configure && \
    make && \
    make install
RUN mv bin/* /usr/local/bin

# bedr package
RUN apt-get update -qq && apt-get -y --no-install-recommends install \
    && install2.r --error \
    bedr

# Check to make sure the binaries are available by loading the bedr library
RUN Rscript -e "library(bedr)"

# Install for mutation signature analysis
RUN R -e "BiocManager::install(c('BSgenome.Hsapiens.UCSC.hg19', 'BSgenome.Hsapiens.UCSC.hg38'))"

# Also install for mutation signature analysis
# qdapRegex is for the fusion analysis
RUN apt-get update -qq && apt-get -y --no-install-recommends install \
    && install2.r --error \
    --deps TRUE \
    deconstructSigs \
    qdapRegex

# packages required for collapsing RNA-seq data by removing duplicated gene symbols
RUN R -e "install.packages('DT', dependencies = TRUE)"
RUN R -e "BiocManager::install(c('rtracklayer'), update = FALSE)"

# Needed to install TCGAbiolinks
RUN apt-get update -qq && apt-get -y --no-install-recommends install \
    && install2.r --error \
    --deps TRUE \
    survival \
    nlme \
    cluster \
    foreign \
    nnet \
    mgcv

# TCGAbiolinks for TMB compare analysis
RUN R -e "BiocManager::install(c('TCGAbiolinks'), update = FALSE)"

# Install python3 data science basics (pandas)
# using pip to get more current versions
RUN apt-get update -qq && apt-get -y --no-install-recommends install python3-pip  python3-dev
RUN pip3 install "numpy==1.17.3" && \
   pip3 install "six==1.13.0" "setuptools==41.6.0" && \
   pip3 install "cycler==0.10.0" "kiwisolver==1.1.0" "pyparsing==2.4.5" "python-dateutil==2.8.1" "pytz==2019.3" && \
   pip3 install "matplotlib==3.0.3" && \
   pip3 install "scipy==1.3.2" && \
   pip3 install "pandas==0.25.3" && \
   pip3 install "snakemake==5.8.1"


# pip install for modules Ras, NF1, and TP53 Classifiers
RUN pip3 install "statsmodels==0.10.2" && \
   pip3 install "plotnine==0.3.0" && \
   pip3 install "scikit-learn==0.19.1" &&\
   pip3 install "rpy2==2.9.3" && \
   pip3 install "seaborn==0.8.1" && \
   pip3 install "jupyter==1.0.0" && \
   pip3 install "ipykernel==4.8.1" && \
   pip3 install "widgetsnbextension==2.0.0" && \
   pip3 install "tzlocal"


# Add curl
RUN apt-get update && apt-get install -y --no-install-recommends curl

# Need for survminer for doing survival analysis
RUN apt-get update -qq && apt-get -y --no-install-recommends install \
    && install2.r --error \
    --deps TRUE \
    survival \
    cmprsk \
    survMisc \
    survminer

# pyreadr for comparative-RNASeq-analysis
RUN pip3 install "pyreadr==0.2.1"

# ggfortify for plotting
RUN apt-get update -qq && apt-get -y --no-install-recommends install \
    && install2.r --error \
    --deps TRUE \
    spatial \
    ggfortify

# package required for immune deconvolution
RUN R -e "install.packages('remotes', dependencies = TRUE)"
RUN R -e "remotes::install_github('icbi-lab/immunedeconv', ref = '493bcaa9e1f73554ac2d25aff6e6a7925b0ea7a6', dependencies = TRUE)"
RUN R -e "install.packages('corrplot', dependencies = TRUE)"

# Install for mutation signature analysis
RUN R -e "BiocManager::install('ggbio')"

# CRAN package msigdbr needed for gene-set-enrichment-analysis
RUN apt-get update -qq && apt-get -y --no-install-recommends install \
    && install2.r --error \
    --deps TRUE \
    msigdbr

# Bioconductor package GSVA needed for gene-set-enrichment-analysis
RUN R -e "BiocManager::install(c('GSVA'), update = FALSE)"

# remote package EXTEND needed for telomerase-activity-prediciton analysis
RUN R -e "devtools::install_github('NNoureen/EXTEND', ref = '467c2724e1324ef05ad9260c3079e5b0b0366420', dependencies = TRUE)"

# Required for installing pdftools, which is a dependency of gridGraphics
RUN apt-get update -qq && apt-get -y --no-install-recommends install \
    libpoppler-cpp-dev

# CRAN package gridGraphics needed for telomerase-activity-prediction
RUN apt-get update -qq && apt-get -y --no-install-recommends install \
    && install2.r --error \
    --deps TRUE \
    gridGraphics

# package required for shatterseek
RUN R -e "withr::with_envvar(c(R_REMOTES_NO_ERRORS_FROM_WARNINGS='true'), remotes::install_github('parklab/ShatterSeek', ref = '83ab3effaf9589cc391ecc2ac45a6eaf578b5046', dependencies = TRUE))"

# MATLAB Compiler Runtime is required for GISTIC, MutSigCV
# Install steps are adapted from usuresearch/matlab-runtime
# https://hub.docker.com/r/usuresearch/matlab-runtime/dockerfile

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -q update && \
    apt-get install -q -y --no-install-recommends \
    xorg

# This is the version of MCR required to run the precompiled version of GISTIC
RUN mkdir /mcr-install-v83 && \
    mkdir /opt/mcr && \
    cd /mcr-install-v83 && \
    wget https://www.mathworks.com/supportfiles/downloads/R2014a/deployment_files/R2014a/installers/glnxa64/MCR_R2014a_glnxa64_installer.zip && \
    unzip -q MCR_R2014a_glnxa64_installer.zip && \
    rm -f MCR_R2014a_glnxa64_installer.zip && \
    ./install -destinationFolder /opt/mcr -agreeToLicense yes -mode silent && \
    cd / && \
    rm -rf mcr-install-v83

WORKDIR /home/rstudio/

# GISTIC installation
RUN mkdir -p gistic_install && \
    cd gistic_install && \
    wget -q ftp://ftp.broadinstitute.org/pub/GISTIC2.0/GISTIC_2_0_23.tar.gz && \
    tar zxf GISTIC_2_0_23.tar.gz && \
    rm -f GISTIC_2_0_23.tar.gz && \
    rm -rf MCR_Installer

RUN chown -R rstudio:rstudio /home/rstudio/gistic_install
RUN chmod 755 /home/rstudio/gistic_install

# pyarrow for comparative-RNASeq-analysis, to read/write .feather files
RUN pip3 install "pyarrow==0.16.0"

#### Please install your dependencies here
#### Add a comment to indicate what analysis it is required for

WORKDIR /rocker-build/
