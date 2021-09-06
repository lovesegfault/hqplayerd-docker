FROM alpine:latest as libgmpris-fetcher
RUN apk add --no-cache wget
ENV LIBGMPRIS_VERSION="2.2.1-8"
ENV LIBGMPRIS="libgmpris_${LIBGMPRIS_VERSION}_amd64.deb"
RUN wget -O /tmp/libgmpris.deb "https://www.sonarnerd.net/src/focal/${LIBGMPRIS}"
################################################################################
FROM alpine:latest as hqplayerd-fetcher
RUN apk add --no-cache wget
ENV HQPLAYERD_VERSION="4.25.2-86amd"
ENV HQPLAYERD="hqplayerd_${HQPLAYERD_VERSION}_amd64.deb"
RUN wget -O /tmp/hqplayerd.deb "https://www.signalyst.eu/bins/hqplayerd/focal/${HQPLAYERD}"
################################################################################
FROM nvidia/cuda:11.4.1-base-ubuntu20.04
ARG DEBIAN_FRONTEND=noninteractive

RUN groupadd render
RUN apt-get update -y
RUN apt-get install -y wget gnupg2
RUN wget -q -O - https://repo.radeon.com/rocm/rocm.gpg.key | apt-key add -
RUN echo 'deb [arch=amd64] https://repo.radeon.com/rocm/apt/debian/ ubuntu main'| tee /etc/apt/sources.list.d/rocm.list
RUN apt-get update -y && apt-get upgrade -y

COPY --from=libgmpris-fetcher /tmp/libgmpris.deb /tmp/libgmpris.deb
RUN apt-get install --no-install-recommends -y /tmp/libgmpris.deb
RUN rm /tmp/libgmpris.deb

COPY --from=hqplayerd-fetcher /tmp/hqplayerd.deb /tmp/hqplayerd.deb
RUN apt-get install --no-install-recommends -y /tmp/hqplayerd.deb
RUN rm /tmp/hqplayerd.deb

# cleanup
RUN rm -rf /var/lib/apt/lists/* && apt-get purge --auto-remove && apt-get clean

# run
ENV LD_LIBRARY_PATH="/opt/rocm-4.3.0/hip/lib/:${LD_LIBRARY_PATH}"
ENTRYPOINT /usr/bin/hqplayerd
