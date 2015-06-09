FROM ubuntu

# Install Python and dependencies
RUN apt-get -qq update && apt-get -qq install build-essential bc python2.7 python3.4 python-dev python-numpy python-scipy wget portmap nis autofs
RUN wget https://bootstrap.pypa.io/get-pip.py && python get-pip.py && rm get-pip.py
RUN pip install docopt

# Set up source code and environment
COPY gidget /gidget
COPY setup/gidget_setup.sh /gidget_setup.sh
RUN chmod -R 700 /gidget_setup.sh
COPY config/gidget.config /gidget/config/gidget.config
RUN chmod -R 700 /gidget
COPY tools/annotate_variation.pl /usr/bin/annotate_variation.pl
# Start gidget wrapper
ENTRYPOINT ["/gidget_setup.sh"]


