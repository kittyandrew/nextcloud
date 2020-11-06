FROM nextcloud:latest as main

# Compatibility layer for Video Converter extension
#    (see: https://github.com/PaulLereverend/NextcloudVideo_Converter)
#
# Binaries from: https://hub.docker.com/r/mwader/static-ffmpeg
COPY --from=mwader/static-ffmpeg:4.3.1-1 /ffmpeg /usr/local/bin/
#
# @Note: you can copy all that binaries in one layer, but if they
#        are used for different things, it's better to add them separately.
#        As practial tests show, adding 2 more COPY layers result in <0Mb
#        difference (if any) for result image (specifically "virtual" memory)
#
# COPY --from=mwader/static-ffmpeg:4.3.1-1 /ffprobe /usr/local/bin/
# COPY --from=mwader/static-ffmpeg:4.3.1-1 /qt-faststart /usr/local/bin/

# Compatibility layers:
#    * ocDownloader (direct download extension, see: https://github.com/e-alfred/ocdownloader)
#      - python
#    * External Storages (SMB/CIFS support)
#      - smbclient
#
# Installation: https://github.com/ytdl-org/youtube-dl#installation
RUN curl -Lo /usr/local/bin/youtube-dl https://yt-dl.org/downloads/latest/youtube-dl \
 && chmod a+rx /usr/local/bin/youtube-dl \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
    python3 \
    smbclient \
 # creating system scope alias for python3 as python
 && update-alternatives --install /usr/bin/python python /usr/bin/python3 1000 \
 # clean up after installs
 && rm -rf /var/lib/apt/lists/* \
 && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false

# Special layer(s) to handle cron job inside docker
#    (see: https://docs.nextcloud.com/server/19/admin_manual/configuration_server/background_jobs_configuration.html)
HEALTHCHECK --interval=5m --timeout=60s \
  CMD curl http://localhost/cron.php || exit 1
