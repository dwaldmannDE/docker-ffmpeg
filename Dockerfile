# Use Debian Bookworm as the base image
FROM debian:bookworm

# Set environment variables to avoid interactive dialog during the build
ENV DEBIAN_FRONTEND=noninteractive

# Update the package list and install build dependencies
RUN apt-get update && apt-get install -y \
    autoconf \
    automake \
    build-essential \
    cmake \
    git \
    libass-dev \
    libfdk-aac-dev \
    libfreetype6-dev \
    libsdl2-dev \
    libtool \
    libva-dev \
    libvdpau-dev \
    libxcb1-dev \
    libxcb-shm0-dev \
    libxcb-xfixes0-dev \
    pkg-config \
    texinfo \
    wget \
    zlib1g-dev \
    nasm \
    yasm \
    libx264-dev \
    libx265-dev \
    libnuma-dev \
    libvpx-dev \
    libmp3lame-dev \
    libopus-dev

# Download and compile FFmpeg from source
RUN git clone --depth 1 https://git.ffmpeg.org/ffmpeg.git ffmpeg && \
    cd ffmpeg && \
    ./configure \
      --enable-gpl \
      --enable-libass \
      --enable-libfdk-aac \
      --enable-libfreetype \
      --enable-libmp3lame \
      --enable-libopus \
      --enable-libvpx \
      --enable-libx264 \
      --enable-libx265 \
      --enable-nonfree && \
    make -j$(nproc) && \
    make install

# Clear apt cache and remove unnecessary files to reduce image size
RUN apt-get clean && rm -rf /var/lib/apt/lists/* && rm -rf /ffmpeg

# Set the entry point to FFmpeg
ENTRYPOINT ["ffmpeg"]
