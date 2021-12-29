FROM alpine:latest as libgmpris-fetcher
RUN apk add --no-cache wget
ENV LIBGMPRIS_VERSION="2.2.1-8"
ENV LIBGMPRIS="libgmpris_${LIBGMPRIS_VERSION}_amd64.deb"
RUN wget -O /tmp/libgmpris.deb "https://www.sonarnerd.net/src/focal/${LIBGMPRIS}"
################################################################################
FROM alpine:latest as hqplayerd-fetcher
RUN apk add --no-cache wget
ENV HQPLAYERD_VERSION="4.28.1-102amd"
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

RUN wget -q -O /tmp/libnvidia-compute.deb "https://launchpadlibrarian.net/556517312/libnvidia-compute-470_470.63.01-0ubuntu0.20.04.2_amd64.deb"
RUN wget -q -O /tmp/nvidia-utils.deb "https://launchpadlibrarian.net/556517343/nvidia-utils-470_470.63.01-0ubuntu0.20.04.2_amd64.deb"
RUN apt-get install -y /tmp/libnvidia-compute.deb
RUN apt-get install -y /tmp/nvidia-utils.deb
RUN rm /tmp/*.deb

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
ENV HOME="/var/lib/hqplayer/home"
ENTRYPOINT ["/usr/bin/hqplayerd"]
