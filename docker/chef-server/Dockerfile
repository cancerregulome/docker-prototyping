FROM ubuntu:latest
RUN apt-get -qq update && apt-get -qq install build-essential && apt-get -qq clean
ONBUILD RUN dpkg -i ... [location of chef server core in mounted volume]
