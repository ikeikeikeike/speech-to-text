FROM jcsilva/docker-kaldi-gstreamer-server:latest

RUN echo "deb http://deb.debian.org/debian jessie main" > /etc/apt/sources.list && \
    echo "deb http://security.debian.org jessie/updates main" >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        htop \
        openssl \
        aptitude \
        ca-certificates \
        curl \
        vim \
        git \
        make \
        sudo \
        mlocate \
        alsa-utils \
    && \
    update-ca-certificates && apt-get clean \
    && \
    echo 'alias ll="ls -alt"' >> ~/.bashrc && \
    echo 'alias ..="cd ../"' >> ~/.bashrc && \
    echo 'alias ...="cd ../../"' >> ~/.bashrc \
    && \
    updatedb \
    && \
    rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

RUN mkdir -p /opt/models/test/models && \
    cd /opt/models/test/models && \
    wget --no-check-certificate https://phon.ioc.ee/~tanela/tedlium_nnet_ms_sp_online.tgz && \
    cp tedlium_nnet_ms_sp_online.tgz /opt/ && \
    tar zxvf tedlium_nnet_ms_sp_online.tgz && \
    cd /opt/kaldi-gstreamer-server && \
    ln -s /opt/models/test .

ENV GST_PLUGIN_PATH /opt/gst-kaldi-nnet2-online/src

# ENTRYPOINT ["sh", "-c", "gst-inspect-1.0", "kaldinnet2onlinedecoder"]
