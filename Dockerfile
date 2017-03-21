################################################################################
# Base image
################################################################################

FROM ubuntu:latest

################################################################################
# Build instructions
################################################################################

# Install packages
RUN apt-get update && apt-get install -my \
  curl \
  wget \
  git \
  default-jdk \
  ant \
  libav-tools \
  ffmpeg \
  nano \
  unzip \
  vim

################################################################################
# Build Mongo Part
################################################################################

# get latest panako build
RUN cd /home && git clone https://github.com/JorenSix/Panako.git
#RUN cd /home && unzip Panako-latest-src.zip
#RUN rm /home/Panako-latest-src.zip

################################################################################
# Build gearman part
################################################################################

# adding a missing file - missing in the latest release (will be removed if author is fixing it)
COPY logging.properties /home/Panako/build

#set correct encoding for ant
#fixing error from author - java encoding :/
ENV JAVA_TOOL_OPTIONS -Dfile.encoding=UTF8
RUN cd /home/Panako/build && ant
RUN cd /home/Panako/build && ant install
RUN chmod 777 /home/Panako/doc/etc/docs2html
RUN cd /home/Panako/build && ant doc

# copy run script and fix permission
RUN cp /home/Panako/doc/panako /usr/bin
RUN chmod 777 /usr/bin/panako

################################################################################
# Configure the rest
################################################################################

# TODO Create filesize parameter
#RUN sed -i "s/user = www-data/user = root/" /etc/php5/fpm/pool.d/www.conf

################################################################################
# Volumes
################################################################################

VOLUME ["/g/google_drive/projects/docker_panako", "/home/audioinput"]

################################################################################
# Ports
################################################################################

EXPOSE 80

################################################################################
# Entrypoint
################################################################################

#ENTRYPOINT ["/usr/bin/supervisord"]
