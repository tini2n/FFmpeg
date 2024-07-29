mkdir -p wasm/dist

INCLUDE_PATHS="-I. -I./fftools"
LIBRARY_PATHS="-Llibavcodec -Llibavfilter -Llibavformat -Llibavresample -Llibavutil -Llibpostproc -Llibswscale -Llibswresample"
SOURCE_FILES="fftools/ffmpeg_enc.c fftools/objpool.c fftools/ffmpeg_mux.c fftools/ffmpeg_mux_init.c fftools/sync_queue.c fftools/thread_queue.c fftools/ffmpeg_sched.c fftools/ffmpeg_dec.c fftools/ffmpeg_demux.c fftools/opt_common.c fftools/ffmpeg_opt.c fftools/ffmpeg_filter.c fftools/ffmpeg_hw.c fftools/cmdutils.c fftools/ffmpeg.c"
LIBRARIES="-lavfilter -lavformat -lavcodec -lswresample -lswscale -lavutil -lm"

ARGS=(
  ${INCLUDE_PATHS}
  ${LIBRARY_PATHS}
  -Qunused-arguments
  -o wasm/dist/ffmpeg.html
  ${SOURCE_FILES}
  ${LIBRARIES}
  -s USE_PTHREADS=1               # Enable pthreads support
  -s ALLOW_MEMORY_GROWTH=1        # Allow memory growth
  -s INITIAL_MEMORY=67108864      # 64 MB initial memory
  -s MAXIMUM_MEMORY=134217728     # 128 MB maximum memory
  -s TOTAL_MEMORY=134217728       # 128 MB total memory
  --bind
  --emrun
)
emcc "${ARGS[@]}"