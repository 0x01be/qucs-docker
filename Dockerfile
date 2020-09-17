FROM 0x01be/qucs:build as build

FROM 0x01be/xpra

USER root
RUN apk add --no-cache --virtual qucs-runtime-dependencies \
    qt5-qtbase \
    qt5-qttools \
    qt5-qtsvg \
    qt5-qtscript

RUN apk add --no-cache --virtual qucs-edge-runtime-dependencies \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing  \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/community  \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
    octave

COPY --from=build /opt/qucs/ /opt/qucs/

ENV PATH $PATH:/opt/qucs/bin/

USER xpra

ENV COMMAND qucs

