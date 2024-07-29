#!/bin/bash -x

# Emscripten version
emcc -v

#EMSDK="/Users/tini2n/emsdk"
EMSDK="/emsdk"
$EMSDK/upstream/bin/llvm-nm --version

# Clean previous builds
emmake make clean
 
CFLAGS="-s USE_PTHREADS -s ALLOW_MEMORY_GROWTH=1 -Os"
LDFLAGS="$CFLAGS -s INITIAL_MEMORY=67108864 -s MAXIMUM_MEMORY=134217728" # 33554432 bytes = 32 MB

# configure FFMpeg with Emscripten
CONFIG_ARGS=(
  --target-os=none             # use none to prevent any os specific configurations
  --arch=x86_32                # use x86_32 to achieve minimal architectural optimization
  --enable-cross-compile       # enable cross compile
  --disable-x86asm             # disable x86 asm
  --disable-inline-asm         # Disable inline asm
  --disable-stripping          # Disable stripping
  --disable-programs           # Disable programs
  --disable-doc                # Disable documentation components

  --nm="$EMSDK/upstream/bin/llvm-nm -g"
  --ar="$EMSDK/upstream/bin/llvm-ar"
  --as="$EMSDK/upstream/bin/llvm-as"
  --ranlib="$EMSDK/upstream/bin/llvm-ranlib"

  --cc=emcc
  --cxx=em++
  --objcc=emcc
  --dep-cc=emcc

  --extra-cflags="$CFLAGS"
  --extra-cxxflags="$CFLAGS"
  --extra-ldflags="$LDFLAGS"

  --disable-all             # Disable all components
  --enable-avcodec          # Enable core codec library
  --enable-avformat         # Enable core format library
  --enable-avfilter         # Enable filtering support
  --enable-swscale          # Enable software scaling
  --enable-swresample       # Enable software resampling
  --enable-filter=scale     # Enable scale filter
)

emconfigure ./configure "${CONFIG_ARGS[@]}"
echo "✅ Configured successfully."

# Build FFmpeg
emmake make -j4