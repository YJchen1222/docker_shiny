# docker_shiny
Creating an R shiny Docker image using Dockerfile

## First: Create Dockerfile and prepare your R shiny program code.
This is the public version of Dockerfile, which is used to build R shiny applications to Docker images.
you need to create Dockerfile and prepare your R shiny program code in the same folder. 
>✍️  You can git clone and modify them.

Dockerfile public version:
```
FROM openanalytics/r-ver:4.4.1

LABEL maintainer="PJLab"

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
RUN R -e "install.packages(c('DT', 'shinyalert', 'shinydashboard'), repos='https://cran.rstudio.com/')"


# copy app.R to the container
COPY  app.R Ui/ Server/ /root/test/

EXPOSE 3838

CMD ["R", "-e", "shiny::runApp('/root/test')"]

```
And the next step you need put the R package and dependency packages you will use in the Dockerfile.

>👀  Default folder structure


## Second: Create Docker image by Dockerfile in the CMD
**Bulid docker Image**

```
docker image build --tag <image_name>:<tag_content> .

```

