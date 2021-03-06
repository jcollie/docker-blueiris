
FROM ubuntu:bionic

ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV WINEPREFIX /root/wine
ENV WINEARCH win64
ENV DISPLAY :0
ENV BLUEIRIS_VERSION=5

RUN apt-get update && \
    apt-get install -y \
        cabextract \
        fluxbox \
        gnupg \
        net-tools \
        software-properties-common \
        supervisor \
        tar \
        unzip \
        wget \
        winbind \
        x11vnc \
        xdotool \
        xvfb && \
    dpkg --add-architecture i386 && \
    wget -nc https://dl.winehq.org/wine-builds/winehq.key && \
    apt-key add winehq.key && \
    apt-add-repository "deb https://dl.winehq.org/wine-builds/ubuntu/ $(lsb_release -cs) main" && \
    wget -qO - https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_$(lsb_release -sr)/Release.key | apt-key add - && \
    apt-add-repository "deb https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_$(lsb_release -sr)/ ./" && \
    apt-get update && apt-get -y install --install-recommends winehq-devel && rm -rf /var/lib/apt/lists/*

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

WORKDIR /root/
RUN wget -O - https://github.com/novnc/noVNC/archive/v1.1.0.tar.gz | tar -xzv -C /root/ && mv /root/noVNC-1.1.0 /root/novnc && ln -s /root/novnc/vnc_lite.html /root/novnc/index.html
RUN wget -O - https://github.com/novnc/websockify/archive/v0.8.0.tar.gz | tar -xzv -C /root/ && mv /root/websockify-0.8.0 /root/novnc/utils/websockify


EXPOSE 8080
# Configure user nobody to match unRAID's settings
 RUN \
 usermod -u 99 nobody && \
 usermod -g 100 nobody && \
 usermod -d /config nobody && \
 chown -R nobody:users /home

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD blueiris.sh /root/blueiris.sh
RUN chmod +x /root/blueiris.sh

RUN \
 cd /usr/bin/ && \
 wget  https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks && \
 chmod +x winetricks && \
 sh winetricks corefonts wininet

RUN mv /root/wine /root/wine_original && \
    mkdir /root/wine

# Expose Port
EXPOSE 8080

CMD ["/usr/bin/supervisord"]
