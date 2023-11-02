# syntax=docker/dockerfile:1

# Run in debian bullseye - the most tested and stable option for MVAPACK
FROM debian:bullseye
# Set environment for ease of access
ENV DEBIAN_FRONTEND noninteractive

# Install octave and dependencies
RUN apt-get update \
    && apt-get install -y xfce4 \
	lightdm \
	wget \
	make 
	
RUN	apt-get update \
	&& apt-get install -y octave \
	octave-image \
	octave-optim \
	octave-struct \
	octave-signal \
	octave-io \
	octave-econometrics \
	octave-statistics
	
RUN	echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections \
	&& dpkg --add-architecture i386 \
	&& apt-get update \
	&& apt-get install -y csh \
	default-jdk \
	default-jre \
	libc6:i386 \
	libstdc++6:i386 \
	libx11-6:i386 \
	libxext6:i386 \
	msttcorefonts \
	liboctave-dev 

RUN apt-get install -y xterm xfonts-75dpi lib32z1

RUN rm /run/reboot-required*
RUN echo "/usr/sbin/lightdm" > /etc/X11/default-display-manager
RUN echo "\
    [LightDM]\n\
	[Seat:*]\n\
	type=xremote\n\
	xserver-hostname=host.docker.internal\n\
	xserver-display-number=0\n\
	autologin-user=root\n\
	autologin-user-timeout=0\n\
	autologin-session=Lubuntu\n\
	" > /etc/lightdm/lightdm.conf.d/lightdm.conf
	
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
RUN echo "pkg install mvapack-20231102.tar.gz;quit" | octave 

# Setup user with manual and logs
RUN mkdir /root/Desktop \
	&& mv mvapack-manual-v2-2-0.pdf /root/Desktop/ \
	&& mv ChangeLog /root/Desktop/ \
	&& echo "pkg load signal image optim struct io econometrics statistics mvapack;\njavaaddpath(glob('/usr/share/java/xercesImpl*'));\njavaaddpath(glob('/usr/share/java/xml-apis*'));" >> /root/.octaverc \
	&& echo "[Desktop Entry]\n\
	Type=Application\n\
	Name=Octave_MVAPACK\n\
	Exec=octave --gui\n\
	Icon=/usr/share/octave/6.4.0/imagelib/octave-logo.svg\n\
	" > /root/Desktop/octave.desktop

# Clean up
RUN rm *.gz \
	&& apt-get clean

# Set docker to open the gui for any X server in windows (mobaxterm, xming, xlaunch)
CMD service dbus start ; service lightdm start
