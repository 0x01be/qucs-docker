FROM 0x01be/qucs:build as build

FROM 0x01be/xpra

USER root
RUN apk add --no-cache --virtual qucs-runtime-dependencies \
    make \
    g++ \
    qt5-qtbase-dev \
    qt5-qttools-dev \
    qt5-qtsvg-dev \
    qt5-qtscript-dev

RUN apk add --no-cache --virtual qucs-edge-runtime-dependencies \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing  \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/community  \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
    octave

COPY --from=build /opt/adms/ /opt/adms/
COPY --from=build /qucs/qucs/main/qucs /opt/qucs/bin/
COPY --from=build /qucs/qucs/main/qucs.real /opt/qucs/bin/
COPY --from=build /qucs/ /qucs/

RUN mkdir -p /opt/qucs/bin/.libs/
RUN chown -R xpra:xpra /opt/qucs/
RUN chown -R xpra:xpra /qucs/
RUN mkdir -p /tmp/.X11-unix
RUN chown -R xpra:xpra /tmp/.X11-unix

USER xpra

ENV PATH $PATH:/opt/qucs/bin/:/opt/adms/bin/

ENV COMMAND qucs

