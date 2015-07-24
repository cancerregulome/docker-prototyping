FROM ubuntu
# Set up environment
ENV DEBIAN_FRONTEND noninteractive
# Install Python and dependencies
RUN apt-get -qq update && apt-get -qq install build-essential bc python2.7 python3.4 python-dev python-numpy python-scipy wget portmap nis autofs gawk && apt-get -qq clean
RUN update-alternatives --set awk /usr/bin/gawk
RUN wget https://bootstrap.pypa.io/get-pip.py && python get-pip.py && rm get-pip.py
RUN pip install docopt
# Install ANNOVAR
COPY tools/annovar.latest.tar.gz /usr/bin/annovar.latest.tar.gz
RUN tar -xf /usr/bin/annovar.latest.tar.gz -C /usr/bin && rm /usr/bin/annovar.latest.tar.gz
# Set up Gidget
COPY gidget /gidget
COPY entrypoints/automount_setup.sh /entrypoints/automount_setup.sh
COPY entrypoints/gidget_bio_ref.sh /entrypoints/gidget_bio_ref.sh
COPY entrypoints/gidget_run_all.sh /entrypoints/gidget_run_all.sh
RUN chmod -R 700 /entrypoints/*
COPY config/gidget.config /gidget/config/gidget.config
RUN chmod -R 700 /gidget
# Set up dependent files
COPY config/auto.proj /etc/auto.proj



