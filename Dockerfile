FROM rocker/verse:4.0.4

# Create environment variables
ENV PATH=/opt/conda/condabin:/opt/conda/bin:${PATH}
ENV RENV_PATHS_CACHE=/renv/cache
ENV RETICULATE_MINICONDA_PATH=/opt/conda/

# Create arguments.  Values passed from docker-compose.yml
ARG SEURAT_VERSION
ARG RENV_VERSION
ARG CONDA_VERSION

# Add environment variables to Renviron
RUN echo "" >> ${R_HOME}/etc/Renviron
RUN echo "RENV_PATHS_CACHE=${RENV_PATHS_CACHE}" >> ${R_HOME}/etc/Renviron
RUN echo "RETICULATE_MINICONDA_PATH=${RETICULATE_MINICONDA_PATH}" >> ${R_HOME}/etc/Renviron

# Install miniconda
WORKDIR /tmp
COPY /common/environment.yml environment.yml

RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-${CONDA_VERSION}-Linux-x86_64.sh -O miniconda.sh && \
    mkdir -p /opt && \
    sh miniconda.sh -b -p /opt/conda && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> /home/rstudio/.shinit && \
    echo "conda activate base" >> /home/rstudio/.shinit && \
    find /opt/conda/ -follow -type f -name '*.a' -delete && \
    find /opt/conda/ -follow -type f -name '*.js.map' -delete && \
    conda update conda && \
    conda clean -afy  && \
    conda env create -f /tmp/environment.yml && \
    echo "conda activate r-reticulate" >> /home/rstudio/.profile && \
    chgrp -R rstudio /opt/conda && \
    chmod 770 -R /opt/conda && \
    adduser rstudio rstudio

# Install the renv package and install packages from lockfile
RUN R -e "install.packages('remotes', repos = c(CRAN = 'https://cloud.r-project.org'))"
RUN R -e "remotes::install_github('rstudio/renv@${RENV_VERSION}')"

WORKDIR /renv
COPY /$SEURAT_VERSION/renv.lock renv.lock
RUN R -e "renv::restore()"

# Copy Rstudio preferences
WORKDIR /home/rstudio/.config/rstudio/
COPY /common/rstudio-prefs.json rstudio-prefs.json
RUN chown rstudio rstudio-prefs.json

# Copy project template script and source from Rprofile.site
WORKDIR /home/rstudio/utilities/
COPY /common/project_template.R project_template.R
RUN echo "source('~/utilities/project_template.R')" >> ${R_HOME}/etc/Rprofile.site

# Set r_data as working directory unless in project directory
RUN echo "wd <- getwd()" >> ${R_HOME}/etc/Rprofile.site
RUN echo "if (wd == '/home/rstudio') {" >> ${R_HOME}/etc/Rprofile.site
RUN echo "setwd('r_data')" >> ${R_HOME}/etc/Rprofile.site >> ${R_HOME}/etc/Rprofile.site
RUN echo "}" >> ${R_HOME}/etc/Rprofile.site

