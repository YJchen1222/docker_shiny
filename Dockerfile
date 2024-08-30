FROM openanalytics/r-ver:4.4.1

LABEL maintainer="PJLAB"

RUN /rocker_scripts/setup_R.sh https://packagemanager.posit.co/cran/__linux__/jammy/latest
RUN echo "\noptions(shiny.port=3838, shiny.host='0.0.0.0')" >> /usr/local/lib/R/etc/Rprofile.site
# system libraries of general use
RUN apt-get update && apt-get install --no-install-recommends -y \
    pandoc \
    pandoc-citeproc \
    libcairo2-dev \
    libxt-dev \
    && rm -rf /var/lib/apt/lists/*

# system library dependency for the euler app
RUN apt-get update && apt-get install --no-install-recommends -y \
    libmpfr-dev \
    && rm -rf /var/lib/apt/lists/*

# basic shiny functionality
RUN R -q -e "options(warn=2); install.packages(c('shiny'))"


# Install R package
RUN R -e "install.packages(c('DT', 'shinyalert', 'bs4Dash'), repos='https://cran.rstudio.com/')"


# copy app.R to the container
COPY  app.R  /root/test/

EXPOSE 3838

CMD ["R", "-e", "shiny::runApp('/root/test')"]
