FROM debian:stable-slim

RUN apt-get update && apt-get install -y \
#  curl \
#  sudo \
#  locales \
#  whois \
  cups \
#  cups-filters \
  cups-pdf \
  printer-driver-all \
	inotify-tools \
	python3-cups
#&& rm -rf /var/lib/apt/lists/*

#RUN sed -i "s/^#\ \+\(en_US.UTF-8\)/\1/" /etc/locale.gen \
#  && locale-gen en_US en_US.UTF-8

#ENV LANG=en_US.UTF-8 \
#  LC_ALL=en_US.UTF-8 \
#  LANGUAGE=en_US:en

#RUN useradd \
#  --groups=sudo,lp,lpadmin \
#  --create-home \
#  --home-dir=/home/print \
#  --shell=/bin/bash \
#  --password=$(mkpasswd print) \
#  print \
#  && sed -i '/%sudo[[:space:]]/ s/ALL[[:space:]]*$/NOPASSWD:ALL/' /etc/sudoers

# Clean downloads and cache
RUN apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && mkdir /var/lib/apt/lists/partial

#COPY etc/cups/cupsd.conf /etc/cups/cupsd.conf

EXPOSE 631
#ENTRYPOINT ["/usr/sbin/cupsd", "-f"]

# We want a mount for these
VOLUME /config
VOLUME /services

# Add scripts
ADD root /
RUN chmod +x /root/*
CMD ["/root/run_cups.sh"]

# Baked-in config file changes
RUN sed -i 's/Listen localhost:631/Listen 0.0.0.0:631/' /etc/cups/cupsd.conf && \
	sed -i 's/Browsing Off/Browsing On/' /etc/cups/cupsd.conf && \
	sed -i 's/<Location \/>/<Location \/>\n  Allow All/' /etc/cups/cupsd.conf && \
	sed -i 's/<Location \/admin>/<Location \/admin>\n  Allow All\n  Require user @SYSTEM/' /etc/cups/cupsd.conf && \
	sed -i 's/<Location \/admin\/conf>/<Location \/admin\/conf>\n  Allow All/' /etc/cups/cupsd.conf && \
	echo "ServerAlias *" >> /etc/cups/cupsd.conf && \
	echo "DefaultEncryption Never" >> /etc/cups/cupsd.conf
