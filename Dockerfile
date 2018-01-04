FROM ubuntu:trusty

RUN apt-get update
RUN apt-get install -y build-essential curl git automake libtool python-docutils

RUN curl -s https://packagecloud.io/install/repositories/varnishcache/varnish5/script.deb.sh | bash
RUN apt-get -y install varnish=5.1.3-1~trusty varnish-dev=5.1.3-1~trusty

#install collectd with varnish (thanks to varnish-dev being installed)
RUN curl -o /tmp/collectd.tar.bz2 https://storage.googleapis.com/collectd-tarballs/collectd-5.7.1.tar.bz2 && \
    (cd /tmp && tar xf collectd.tar.bz2 && mv collectd-5.7.1 /tmp/collectd && rm collectd.tar.bz2) && \
    (cd /tmp/collectd && ./configure --prefix / && make && make install)

#install libvmod-dns to allow reverse dns queries
RUN git clone https://github.com/knq/libvmod-dns.git && cd libvmod-dns && ./autogen.sh && ./configure && make && sudo make install

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV VCL_CONFIG              /etc/varnish/default.vcl
ENV CACHE_SIZE              256m
ENV VARNISHD_PARAMS         ""

ADD run.sh /usr/local/bin/run
RUN chmod +x /usr/local/bin/run

CMD ["/usr/local/bin/run"]
EXPOSE 80
