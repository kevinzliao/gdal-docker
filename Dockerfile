##
# geodata/gdal
#
# This creates an Ubuntu derived base image that installs the latest GDAL
# subversion checkout compiled with a broad range of drivers.  The build process
# is based on that defined in
# <https://github.com/OSGeo/gdal/blob/trunk/.travis.yml>
#

# Ubuntu 14.04 Trusty Tahyr
FROM ubuntu:trusty

MAINTAINER Homme Zwaagstra <hrz@geodata.soton.ac.uk>

RUN apt-get update && apt-get install -y dos2unix

# Install the application.
COPY . /usr/local/src/gdal-docker/
RUN find ./usr/local/src/gdal-docker/ -type f -print0 | xargs -0 dos2unix && apt-get --purge remove -y dos2unix && rm -rf /var/lib/apt/lists/*
RUN /usr/local/src/gdal-docker/build.sh

# Externally accessible data is by default put in /data
WORKDIR /data
VOLUME ["/data"]

# Output version and capabilities by default.
CMD gdalinfo --version && gdalinfo --formats && ogrinfo --formats
