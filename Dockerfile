FROM ubuntu:latest

ARG CROSSTOOL_NG_COMMIT_SHA 5659366

WORKDIR /root

RUN apt-get update && \
    apt-get install --yes \
        git \
        gcc \
        g++ \
        gperf \
        bison \
        flex \
        texinfo \
        help2man \
        make \
        libncurses5-dev \
        autoconf \
        automake \
        libtool \
        libtool-bin \
        gawk \
        wget \
        bzip2 \
        xz-utils \
        unzip \
        patch \
        curl \
        libstdc++6 curl nano tree vim && \
        apt-get clean --yes && rm -rf /var/lib/apt/lists/*

RUN git clone --depth 1 -n https://github.com/crosstool-ng/crosstool-ng.git

RUN git checkout -b master ${CROSSTOOL_NG_COMMIT_SHA}

RUN cd crosstool-ng && ./bootstrap && ./configure && make && make install && cd .. && rm -rf crosstool-ng

RUN groupadd -g 4242 builder && useradd -r -u 4242 --create-home -g builder builder

RUN echo "Set disable_coredump false" >> /etc/sudo.conf

WORKDIR /home/builder

USER builder

ENTRYPOINT ["ct-ng"]
