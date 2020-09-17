FROM alpine

RUN apk add --no-cache --virtual qucs-build-dependencies \
    git \
    build-base \
    ccache \
    autoconf \
    automake \
    cmake \
    bison \
    flex \
    gperf \
    python3-dev \
    python3-tkinter \
    pkgconfig \
    libtool \
    libx11-dev \
    qt5-qtbase-dev \
    qt5-qttools-dev \
    qt5-qtsvg-dev \
    qt5-qtscript-dev \
    doxygen \
    graphviz \
    texlive-full \
    gnuplot \
    libxml2-dev \
    perl-xml-libxml \
    perl-gd

RUN apk add --no-cache --virtual qucs-edge-runtime-dependencies \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing  \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/community  \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
    octave

RUN git clone --depth 1 https://github.com/Qucs/ADMS.git /adms

WORKDIR /adms

RUN ./bootstrap.sh
RUN ./configure --prefix=/opt/adms
RUN make install

ENV LD_LIBRARY_PATH /usr/lib/:/opt/adms/lib/
ENV PATH $PATH:/opt/adms/bin/

ENV REVISION refactor+qt5-18

RUN git clone --recursive --branch $REVISION https://github.com/Qucs/qucs.git /qucs

WORKDIR /qucs
RUN ln -s /qucs/qucsator /qucs/qucs-core
ENV QT qt5
RUN ./bootstrap

WORKDIR /qucs/qucs
RUN ./configure --prefix=/opt/qucsa --with-qt-name=Qt5 --disable-doc
RUN make install

