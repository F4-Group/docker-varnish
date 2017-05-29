FROM phusion/baseimage:0.9.22

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

RUN apt-get update
RUN apt-get install -y build-essential curl

RUN curl -s https://packagecloud.io/install/repositories/varnishcache/varnish5/script.deb.sh | bash
RUN apt-get -y install varnish varnish-dev

#install collectd with varnish (thanks to varnish-dev being installed)
RUN curl -o /tmp/collectd.tar.bz2 https://storage.googleapis.com/collectd-tarballs/collectd-5.7.1.tar.bz2 && \
    (cd /tmp && tar xf collectd.tar.bz2 && mv collectd-5.7.1 /tmp/collectd && rm collectd.tar.bz2) && \
    (cd /tmp/collectd && ./configure --prefix / && make && make install)

ENV VCL_CONFIG              /etc/varnish/default.vcl
ENV CACHE_SIZE              256m
ENV VARNISHD_PARAMS         ""

ADD collectd.sh /etc/service/collectd/run
ADD varnish.sh /etc/service/varnish/run

EXPOSE 80

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
