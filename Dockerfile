ARG UBUNTU_TAG

FROM ubuntu:${UBUNTU_TAG}

ENV DEBIAN_FRONTEND=noninteractive

ARG APSIM_VERSION

RUN apt-get update \
    && apt-get install -y --no-install-recommends libsqlite3-dev tzdata curl ca-certificates build-essential

RUN ln -fs /usr/share/zoneinfo/Pacific/Auckland /etc/localtime && dpkg-reconfigure -f noninteractive tzdata

RUN curl -o /tmp/packages-microsoft-prod.deb https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb

RUN curl -o /tmp/ApsimSetup.deb https://builds.apsim.info/api/nextgen/download/$APSIM_VERSION/Linux 

RUN apt-get update \
    && apt -y install /tmp/packages-microsoft-prod.deb \
    && apt-get update \
    && apt-get install -y --no-install-recommends dotnet-runtime-6.0 

RUN apt-get update \
    && apt -y install --no-install-recommends /tmp/ApsimSetup.deb \
    && chmod +x /usr/local/bin/* 

RUN rm -rf /tmp/ApsimSetup.deb /tmp/packages-microsoft-prod.deb \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/downloaded_packages \ 
    && apt-get -y autoremove --purge
