FROM ubuntu:trusty

RUN apt-get update
RUN apt-get install -y build-essential curl

RUN apt-get install -y apt-transport-https
RUN curl https://repo.varnish-cache.org/GPG-key.txt | apt-key add -
RUN echo "deb https://repo.varnish-cache.org/ubuntu/ trusty varnish-4.1" >> /etc/apt/sources.list.d/varnish-cache.list
RUN apt-get update && apt-get upgrade -y -o Dpkg::Options::="--force-confold"
RUN apt-get -y install varnish varnish-dev

#install collectd with varnish (thanks to varnish-dev being installed)
RUN curl -o /tmp/collectd.tar.bz2 https://storage.googleapis.com/collectd-tarballs/collectd-5.7.1.tar.bz2 && \
    (cd /tmp && tar xf collectd.tar.bz2 && mv collectd-5.7.1 /tmp/collectd && rm collectd.tar.bz2) && \
    (cd /tmp/collectd && ./configure --prefix / && make && make install)

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV VCL_CONFIG              /etc/varnish/default.vcl
ENV CACHE_SIZE              256m
ENV VARNISHD_PARAMS         ""

ADD run.sh /usr/local/bin/run
RUN chmod +x /usr/local/bin/run

CMD ["/usr/local/bin/run"]
EXPOSE 80
