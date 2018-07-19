FROM stefanfritsch/r_statup:3.5.0
MAINTAINER Stefan Fritsch <stefan.fritsch@stat-up.com>

EXPOSE 3838

RUN mkdir -p /var/log/shiny-server \
    && useradd -m shiny \
    && chown shiny:shiny /var/log/shiny-server \
    && cp -R /opt/microsoft/ropen/3.5.0/lib64/R/library/shiny/examples/03_reactivity /app \
    && chown shiny:shiny /app

COPY shiny.sh /etc/service/shiny/run

RUN chmod +x /etc/service/shiny/run

RUN apt-get update \
    && apt-get install -y --no-install-recommends gdebi-core \
    && wget https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-1.5.7.907-amd64.deb \
    && gdebi -n shiny-server-1.5.7.907-amd64.deb \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && mkdir -p /opt/shiny_bookmark_state \
    && chown shiny:shiny /opt/shiny_bookmark_state \
    && chown -R shiny:shiny /opt/microsoft/ropen/3.5.0/lib64/R/library

#    && wget --no-verbose https://download3.rstudio.org/ubuntu-14.04/x86_64/VERSION -O "version.txt" \
#    && VERSION=$(cat version.txt)  \
#    && wget --no-verbose "https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-$VERSION-amd64.deb" -O ss-latest.deb\
#    && gdebi -n ss-latest.deb \
#    && rm -f version.txt ss-latest.deb \

COPY shiny-server.conf /etc/shiny-server/shiny-server.conf

