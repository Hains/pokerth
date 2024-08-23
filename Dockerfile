FROM debian:bullseye

ENV TZ=Europe/Berlin

USER root

# add deb-src repos
RUN echo '\ndeb-src http://deb.debian.org/debian/ bullseye main' >> /etc/apt/sources.list
RUN echo '\ndeb-src http://security.debian.org/debian-security bullseye-security main contrib' >> /etc/apt/sources.list
RUN echo '\ndeb-src http://deb.debian.org/debian/ bullseye-updates main contrib' >> /etc/apt/sources.list
RUN echo '\ndeb-src http://deb.debian.org/debian bullseye-backports main contrib' >> /etc/apt/sources.list


RUN apt update && DEBIAN_FRONTEND="noninteractive" apt build-dep pokerth -y && apt install -y \
    libmysql++-dev qt5-qmake git ca-certificates
# libboost downgrade to 1.67 - first remove the wrong version installed with build-dep:
RUN apt purge -y libboost-dev libboost-filesystem1.74.0 libboost-program-options1.74.0 libboost-random1.74.0 libboost-system1.74.0
RUN apt purge -y libboost-date-time1.74.0 libboost-iostreams1.74.0 libboost-regex1.74.0 libboost-serialization1.74.0 libboost-thread1.74.0
RUN apt autoremove -y # just in case of missing/keeping some conflicting dep packages with boost 1.74
# switch to debian buster repos
RUN sed -i 's/bullseye/buster/g' /etc/apt/sources.list
RUN apt update || : # ignore stderror as a few links will return 404 with this direct sed string replacement
# install 1.67 libboost
RUN apt install libboost-dev libboost-thread-dev libboost1.67-dev libboost-filesystem1.67-dev libboost-program-options1.67-dev libboost-thread1.67-dev -y
RUN apt install libboost-random1.67-dev libboost-system1.67-dev libboost-date-time1.67-dev libboost-iostreams1.67-dev libboost-regex1.67-dev libboost-serialization1.67-dev -y
# ... propably the use of the versionless libboost-dev and libboost-thread-dev metapackages is unnecessary

RUN sed -i 's/buster/bullseye/g' /etc/apt/sources.list # revert repos to bullseye
RUN apt update # not reallyy necessary as we do not need any further apt usage
RUN apt clean -y && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* # common final deb based container cleanup

RUN cd /opt && git clone https://github.com/pokerth/pokerth.git && cd pokerth && git checkout stable && \
    qmake CONFIG+="client c++11" QMAKE_CFLAGS_ISYSTEM="" -spec linux-g++ pokerth.pro && make

ENTRYPOINT ["/bin/bash"]
