FROM stefanfritsch/r_statup:3.5.1.20190828
MAINTAINER Stefan Fritsch <stefan.fritsch@stat-up.com>

ENV RVERSION="3.5.1"
ENV SHINYVERSION="1.5.9.923"

EXPOSE 3838

COPY shiny.sh /etc/service/shiny/run
RUN chmod +x /etc/service/shiny/run
RUN useradd -m -u 1000 shiny

RUN apt-get update \
    && apt-get install -y --no-install-recommends gdebi-core \
    && wget https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-${SHINYVERSION}-amd64.deb \
    && gdebi -n shiny-server-${SHINYVERSION}-amd64.deb \
    && rm shiny-server-${SHINYVERSION}-amd64.deb \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && mkdir -p /opt/shiny_bookmark_state \
    && chown shiny:shiny /opt/shiny_bookmark_state \
    && chown -R shiny:shiny /opt/microsoft/ropen/${RVERSION}/lib64/R/library \
    && mkdir -p /var/log/shiny-server \
    && chown shiny:shiny /var/log/shiny-server \
    && cp -R /opt/microsoft/ropen/${RVERSION}/lib64/R/library/shiny/examples/03_reactivity /app \
    && chown shiny:shiny /app
    
COPY shiny-server.conf /etc/shiny-server/shiny-server.conf

