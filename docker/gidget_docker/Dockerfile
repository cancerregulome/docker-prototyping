FROM ubuntu
# Set up environment
ENV DEBIAN_FRONTEND noninteractive
# Install Python and dependencies
RUN apt-get -qq update && apt-get -qq install build-essential bc python2.7 python3.4 python-dev python-numpy python-scipy wget portmap nis autofs
RUN wget https://bootstrap.pypa.io/get-pip.py && python get-pip.py && rm get-pip.py
RUN pip install docopt
# Install ANNOVAR
COPY tools/annovar.latest.tar.gz /usr/bin/annovar.latest.tar.gz
RUN tar -xf /usr/bin/annovar.latest.tar.gz && rm /usr/bin/annovar.latest.tar.gz
# Set up Gidget
COPY gidget /gidget
COPY setup/gidget_setup.sh /gidget_setup.sh
RUN chmod -R 700 /gidget_setup.sh
COPY config/gidget.config /gidget/config/gidget.config
RUN chmod -R 700 /gidget
# Start gidget wrapper
ENTRYPOINT ["/gidget_setup.sh"]


