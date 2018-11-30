FROM centos:6.9
RUN yum groupinstall -y "Development tools" \
        && yum install -y epel-release perl-Sys-Syslog.x86_64 \
        && yum install -y wget kernel-devel-$(uname -r) \
&& yum install -y libXrender-devel libXt-devel libXtst-devel \
        libcurl-devel openssl-devel pam-devel alsa-lib-devel \
        ccache cups-devel freetype-devel.x86_64 \
&& rpm --import http://repos.azulsystems.com/RPM-GPG-KEY-azulsystems \
        && curl -o /etc/yum.repos.d/zulu.repo http://repos.azulsystems.com/rhel/zulu.repo \
        && yum install -y zulu-8 \
        && java -version

RUN wget -q ftp://ftp.mirrorservice.org/sites/sourceware.org/pub/gcc/releases/gcc-7.3.0/gcc-7.3.0.tar.gz \
        && tar xf gcc-7.3.0.tar.gz

RUN cd /gcc-7.3.0 && contrib/download_prerequisites

RUN cd /gcc-7.3.0 && ./configure --disable-multilib --enable-languages=c,c++

RUN cd /gcc-7.3.0 && make -j `grep ^proc /proc/cpuinfo | wc -l` \
        && make install && echo "/usr/local/lib64" | tee /etc/ld.so.conf.d/local-x86_64.conf \
        && ldconfig -v \
	&& make `grep ^proc /proc/cpuinfo | wc -l` check \
        && rm -rf /gcc-7.3.0* \
        && echo gcc --version

#RUN curl https://cmake.org/files/v3.4/cmake-3.4.3-Linux-x86_64.tar.gz | tar zxf - \
#        && /cmake-3.4.3-Linux-x86_64/bin/cmake --version
#
#RUN curl https://www.python.org/ftp/python/2.7.15/Python-2.7.15.tgz | tar zxf - \
#        && cd Python-2.7.15 \
#        && ./configure --enable-optimizations \
#        &&  make -j `grep ^proc /proc/cpuinfo | wc -l` altinstall \
#        && rm -rf /Python-2.7.15 \
#        && python2.7 -V
#
#ENV PATH="/cmake-3.4.3-Linux-x86_64/bin:${PATH}"

