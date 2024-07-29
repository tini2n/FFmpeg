# Use the official Emscripten SDK image
FROM emscripten/emsdk:3.1.64

ARG GITHUB_PAT
ENV GITHUB_PAT=${GITHUB_PAT}

# Install necessary packages
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    && apt-get clean

# Set the working directory
WORKDIR /usr/src/app

# Clone FFmpeg fork
RUN git clone https://${GITHUB_PAT}:x-oauth-basic@github.com/tini2n/FFmpeg.git

# Change directory to FFmpeg
WORKDIR /usr/src/app/FFmpeg

# Copy your build script into the container
# COPY config-n-build.sh /usr/src/app/FFmpeg/config-n-build.sh
# COPY generate-wasm.sh /usr/src/app/FFmpeg/generate-wasm.sh

# Make the build script executable
# RUN chmod +x config-n-build.sh generate-wasm.sh

# Run the build script
RUN ./config-n-build.sh

# Run the generate-wasm script
RUN ./generate-wasm.sh

# Expose the build output directory as a volume
VOLUME ["/usr/src/app/FFmpeg/wasm/dist"]

# Set the entry point to the shell
ENTRYPOINT ["/bin/bash"]
