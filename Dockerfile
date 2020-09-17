FROM 0x01be/qucs:build as build

FROM 0x01be/xpra

COPY --from=build /qucs /qucs

USER root
RUN apk add --no-cache --virtual qucs-runtime-dependencies \
   libx11 \
   qt5-qtbase \
   qt5-qttools \
   qt5-qtsvg \
   qt5-qtscript

COPY --from=build /opt/adms /opt/adms
ENV LD_LIBRARY_PATH /usr/lib/:/opt/adms/lib/
ENV PATH $PATH:/opt/adms/bin/

RUN ln -s /qucs/qucs/main/qucs.real /bin/qucs.real

RUN apk add --no-cache --virtual qucs-debug-dependencies \
   libx11-dev \
   qt5-qtbase-dev \
   qt5-qttools-dev \
   qt5-qtsvg-dev \
   qt5-qtscript-dev \
   libtool \
   g++ \
   gdb

WORKDIR /qucs/qucs

ENV COMMAND "libtool --mode=execute gdb --args main/qucs.real -i examples/bandpass.sch"

