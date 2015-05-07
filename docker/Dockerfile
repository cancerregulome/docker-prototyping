FROM ubuntu:14.04
RUN apt-get -y update && apt-get -y install build-essential software-properties-common wget
RUN add-apt-repository 'deb http://archive.ubuntu.com/ubuntu trusty-backports main restricted universe'
RUN add-apt-repository 'deb http://cran.fhcrc.org/bin/linux/ubuntu trusty/'
RUN apt-get -y update
RUN apt-get install -y --force-yes r-base r-base-dev gdebi-core libapparmor1 
RUN wget http://download2.rstudio.org/rstudio-server-0.98.1103-amd64.deb
RUN gdebi -n rstudio-server-0.98.1103-amd64.deb
COPY config/rserver.conf /etc/rstudio/rserver.conf
COPY config/rsession.conf /etc/rstudio/rsession.conf
EXPOSE 8787
#RUN rstudio-server start

