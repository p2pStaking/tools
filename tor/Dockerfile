# https://github.com/lncm/docker-tor/blob/master/Dockerfile

ARG VERSION=0.4.7.16

ARG USER=toruser
ARG UID=1000

ARG DIR=/data

FROM debian:stable-slim as preparer 

RUN apt update
RUN apt -y install gpg gpg-agent curl

ARG VERSION
#
ADD https://dist.torproject.org/tor-$VERSION.tar.gz.sha256sum.asc ./
ADD https://dist.torproject.org/tor-$VERSION.tar.gz.sha256sum ./
ADD https://dist.torproject.org/tor-$VERSION.tar.gz ./

#https://support.torproject.org/little-t-tor/
RUN gpg --auto-key-locate nodefault,wkd --locate-keys ahf@torproject.org
RUN gpg --auto-key-locate nodefault,wkd --locate-keys dgoulet@torproject.org
RUN gpg --auto-key-locate nodefault,wkd --locate-keys nickm@torproject.org

RUN gpg --output ./tor.keyring --export 514102454D0A87DB0767A1EBBE6A0531C18A9179 B74417EDDF22AC9F9E90F49142E86A2A11F48D36 2133BC600AB133E1D826D173FE43009C4607B1FB

RUN gpgv --keyring ./tor.keyring ./tor-$VERSION.tar.gz.sha256sum.asc ./tor-$VERSION.tar.gz.sha256sum 
  

RUN sha256sum -c tor-$VERSION.tar.gz.sha256sum

# Extract
RUN tar -xzf "/tor-$VERSION.tar.gz" && \
    rm  -f   "/tor-$VERSION.tar.gz"

FROM debian:stable-slim as builder

ARG VERSION

RUN apt update
RUN apt -y install libevent-dev libssl-dev zlib1g-dev build-essential

WORKDIR /tor-$VERSION/

COPY  --from=preparer /tor-$VERSION/  ./

RUN ./configure --sysconfdir=/etc --datadir=/var/lib
RUN make -j$(nproc)
RUN make install

RUN ls -la /etc
RUN ls -la /etc/tor
RUN ls -la /var/lib
RUN ls -la /var/lib/tor

FROM debian:stable-slim as final

ARG VERSION
ARG USER
ARG DIR

LABEL maintainer="p2pstaking"

# Libraries (linked)
COPY  --from=builder /usr/lib /usr/lib
# Copy all the TOR files
COPY  --from=builder /usr/local/bin/tor*  /usr/local/bin/

# NOTE: Default GID == UID == 1000
RUN adduser --disabled-password \
            --home "$DIR/" \
            --gecos "" \
            "$USER"
USER $USER

VOLUME /etc/tor
VOLUME /var/lib/tor

EXPOSE 9050 9051 29050 29051

ENTRYPOINT ["tor"]
