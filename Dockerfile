FROM        frolvlad/alpine-mono

LABEL       author="BrainP4in" maintainer="BrainP4in@blueberry-hood-clan.de"

RUN         echo "http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
            && apk add --update --no-cache openssl curl sqlite libgdiplus wine winetricks xvfb xvfb-run gnutls \
            && adduser -D -h /home/container container 
            
RUN         echo "Configuring WINE and installing dependencies." \
            && WINEDEBUG=-all WINEARCH=win64 winecfg > /dev/null \
            && WINEDEBUG=-all winetricks -q msxml3 > /dev/null \
            && WINEDEBUG=-all winetricks -q dotnet40 > /dev/null

ADD         bin/* /usr/local/bin/

RUN         chmod +x /bin/* \
            && ln -s /usr/bin/wine64 /usr/bin/wine


USER        container
ENV         HOME=/home/container USER=container
WORKDIR     /home/container

COPY       ./entrypoint.sh /entrypoint.sh

CMD         ["/bin/ash", "/entrypoint.sh"]
