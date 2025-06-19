FROM ubuntu:plucky
# ubuntu:24.04 aka ubuntu:noble might also work with the following procedure (changing deb-src entries from plucky to noble)

ENV TZ=Europe/Berlin

USER root

RUN echo '\nTypes: deb-src' >> /etc/apt/sources.list.d/ubuntu.sources
RUN echo 'URIs: http://archive.ubuntu.com/ubuntu/' >> /etc/apt/sources.list.d/ubuntu.sources
RUN echo 'Suites: plucky plucky-updates plucky-backports' >> /etc/apt/sources.list.d/ubuntu.sources
RUN echo 'Components: main universe restricted multiverse' >> /etc/apt/sources.list.d/ubuntu.sources
RUN echo 'Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg' >> /etc/apt/sources.list.d/ubuntu.sources

# build-deps
RUN apt update && DEBIAN_FRONTEND="noninteractive" && apt upgrade -y
RUN apt install -y wget git ca-certificates build-essential cmake libgsasl-dev libtinyxml-dev debhelper libircclient-dev libmysql++-dev \ 
    libwebsocketpp-dev libprotobuf-dev protobuf-compiler libsdl-mixer1.2-dev libcurl4-gnutls-dev libsdl1.2-dev libgcrypt20-dev libsqlite3-dev \
    qt6-base-dev qt6-svg-dev qt6-declarative-dev qt6-tools-dev linguist-qt6 qt6-websockets-dev libqca-qt6-dev libboost1.88-all-dev ninja-build
# INFO: libmysql++-dev only required for official_server build, libircclient-dev is obsolete?, libtinyxml-dev is necessary only for dedicated server or official_server build (e.g. for chatcleaner)
## INFO: in order to run a gui client inside a docker container you should use distrobox as it automatically integrates necessary xserver components

# cleanup
RUN apt clean -y && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /root/boost*

# fetch repo:
RUN cd /opt && git clone https://github.com/pokerth/pokerth.git && cd pokerth && git checkout qt6-qml

# the following will prepare for qt6 widget client build:
# RUN cd /opt/pokerth && cmake -G Ninja -S. -B./build -DBUILD_CLIENT=ON

# the following will prepare for qt6 qml client build:
RUN cd /opt/pokerth && cmake -G Ninja -S. -B./build -DBUILD_CLIENT=ON -DBUILD_QML_CLIENT=ON

# the following will prepare for official_server build:
# RUN cd /opt/pokerth && cmake -G Ninja -S. -B./build -DBUILD_CLIENT=OFF -DBUILD_DBOFFICIAL=ON

# the following will prepare for dedicated server build without database connection:
# RUN cd /opt/pokerth && cmake -G Ninja -S. -B./build -DBUILD_CLIENT=OFF

# some stuff
RUN cd /opt/pokerth && mkdir -p src/third_party/protobuf && rm src/third_party/protobuf/* 2> /dev/null || true
RUN cd /opt/pokerth && protoc --proto_path=. --cpp_out=src/third_party/protobuf pokerth.proto
RUN cd /opt/pokerth && protoc --proto_path=. --cpp_out=src/third_party/protobuf chatcleaner.proto   
RUN cd /opt/pokerth && cp -r data/ ./build/. 

# compile:
RUN cd /opt/pokerth && cmake --build ./build

# install
# RUN cd /opt/pokerth && cmake --install ./build

ENTRYPOINT ["/bin/bash"]
