# syntax=docker/dockerfile:1

# Run in debian bullseye - the most tested and stable option for MVAPACK
FROM debian:bullseye
# Set environment for ease of access
ENV DEBIAN_FRONTEND noninteractive

# Install base image
RUN apt-get update && apt-mark hold iptables && \
      apt-get install -y dbus-x11 \
      psmisc \
      xdg-utils \
      x11-xserver-utils \
      x11-utils \
      xfce4 


RUN apt-get update && apt-get install -y numix-gtk-theme \
      libgtk-3-bin \
      libpulse0 \
      mousepad \
	  make \
      xfce4-notifyd \
      xfce4-taskmanager \
      xfce4-terminal \
      xfce4-battery-plugin \
      xfce4-clipman-plugin \
      xfce4-cpufreq-plugin \
      xfce4-cpugraph-plugin \
      xfce4-diskperf-plugin \
      xfce4-datetime-plugin \
      xfce4-fsguard-plugin \
      xfce4-genmon-plugin \
      xfce4-indicator-plugin \
      xfce4-netload-plugin \
      xfce4-places-plugin \
      xfce4-sensors-plugin \
      xfce4-smartbookmark-plugin \
      xfce4-systemload-plugin \
      xfce4-timer-plugin \
      xfce4-verve-plugin \
      xfce4-weather-plugin \
      xfce4-whiskermenu-plugin \
      libxv1 \
      mesa-utils \
      mesa-utils-extra && \
    sed -i 's%<property name="ThemeName" type="string" value="Xfce"/>%<property name="ThemeName" type="string" value="Raleigh"/>%' /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml

#Install octave and dependents
RUN	apt-get update \
	&& apt-get install -y octave 
	
RUN apt-get install -y sudo
	
RUN apt-get update \
	&& apt-get install -y octave-image \
	octave-optim \
	octave-struct \
	octave-signal \
	octave-io \
	octave-econometrics \
	octave-statistics

#Install requirements for mvapack
RUN echo "deb http://deb.debian.org/debian/ bullseye main contrib non-free" >> /etc/apt/sources.list
RUN	echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections \
	&& apt-get install -y software-properties-common \
	&& dpkg --add-architecture i386 \
	&& apt-get update \
	&& apt-get install -y csh \
	default-jdk \
	default-jre \
	libc6:i386 \
	libstdc++6:i386 \
	libx11-6:i386 \
	libxext6:i386 \
	ttf-mscorefonts-installer \
	liboctave-dev 

RUN apt-get install -y xterm xfonts-75dpi lib32z1
	
ENV DISPLAY=host.docker.internal:0.0

# Install MVAPACK and dependencies
RUN wget -q https://bionmr.unl.edu/files/mvapack-downloads/mvapack-20231102.tar.gz 
RUN wget -q https://bionmr.unl.edu/files/mvapack/mvapack-manual-v2-2-0.pdf 
RUN wget -q https://bionmr.unl.edu/files/mvapack-downloads/mvapack-20220624.log/mvapack/ChangeLog 
RUN mkdir /opt/nmrpipe
RUN wget -q https://www.ibbr.umd.edu/nmrpipe/install.com 
RUN wget -q https://www.ibbr.umd.edu/nmrpipe/binval.com 
RUN wget -q https://www.ibbr.umd.edu/nmrpipe/NMRPipeX.tZ 
RUN wget -q https://www.ibbr.umd.edu/nmrpipe/s.tZ 
RUN chmod 777 *.com \
	&& chmod 777 *.tZ \
	&& mv *.com /opt/nmrpipe \
	&& mv *.tZ /opt/nmrpipe
RUN sudo sh -c "cd /opt/nmrpipe ; ./install.com option +type linux212_64"
RUN echo "pkg install mvapack-20231102.tar.gz; quit" | octave 

ENV NMR_IO_TIMEOUT=0
ENV NMR_IO_SELECT=0
ENV NMR_AUTOSWAP=1
ENV NMR_PLUGIN_FUN=SMILE:FLATT
ENV NMR_PLUGIN_INFO="-nDim -sample sName ... MD NUS Reconstruction":"-bw ... 1D FLATT Baseline Correction"
ENV BINTYPE=linux212_64
ENV BINVAL=nmrbin.linux212_64
ENV NMRBASE=/opt/nmrpipe
ENV NMRBIN=${NMRBASE}/${BINVAL}
ENV NMR_CHECKARGS=ALL
ENV NMR_FSCHECK=NO
ENV NMRBINTYPE=$BINVAL
ENV NMRTXT=${NMRBASE}/nmrtxt
ENV TCLPATH=${NMRBASE}/com
ENV TCL_LIBRARY=${NMRBASE}/NMRTCL/tcl8.4
ENV TK_LIBRARY=${NMRBASE}/NMRTCL/tk8.4
ENV BLT_LIBRARY=${NMRBASE}/NMRTCL/blt2.4z
ENV NMRPIPE_TCL_LIB=${NMRBASE}/NMRTCL/tcl8.4
ENV NMRPIPE_TK_LIB=${NMRBASE}/NMRTCL/tk8.4
ENV NMRPIPE_BLT_LIB=${NMRBASE}/NMRTCL/blt2.4z
ENV MANPATH=${NMRBASE}/man:/usr/man:/usr/share/man:/usr/share/catman:/X11/usr/man:/usr/local/man
ENV PATH=$PATH:${NMRBIN}:${TCLPATH}:/usr/X11R6/bin:/usr/X11/bin


# Setup user with manual and logs
RUN mkdir /root/Desktop \
	&& mv mvapack-manual-v2-2-0.pdf /root/Desktop/ \
	&& mv ChangeLog /root/Desktop/ \
	&& echo "pkg load signal image optim struct io econometrics statistics mvapack;\njavaaddpath(glob('/usr/share/java/xercesImpl*'));\njavaaddpath(glob('/usr/share/java/xml-apis*'));" >> /root/.octaverc 
	
# Clean up
RUN rm *.gz 
RUN apt-get clean

# Set docker to open the gui for any X server in windows (mobaxterm, xming, xlaunch)
CMD ["startxfce4"]
