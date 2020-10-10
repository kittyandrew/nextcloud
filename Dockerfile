FROM nextcloud:stable as pdftron-builder
# Building PDFTron
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
 # Build dependencies
 wget git build-essential cmake swig \
 # Install PDFTron package (Optimization Pipeline)
 && mkdir /pdftron \
 && cd /pdftron \
 # Clone public wrappers repo
 && git clone https://github.com/PDFTron/PDFNetWrappers \
 && cd PDFNetWrappers/PDFNetC \
 # Download and unpack PDFNetC
 #    see: https://www.pdftron.com/documentation/python/get-started/python3/linux
 && wget http://www.pdftron.com/downloads/PDFNetC64.tar.gz \
 && tar xvzf PDFNetC64.tar.gz \
 && mv PDFNetC64/Headers/ . \
 && mv PDFNetC64/Lib/ . \
 && rm PDFNetC64.tar.gz \
 # Compile PDFTron
 && cd .. \
 && mkdir Build \
 && cd Build \
 && cmake -D BUILD_PDFNetPHP=ON .. \
 && make \
 && make install \
 && php --ini \
 && cd .. \
 && rm -rf Build
 # && rm -rf /var/lib/apt/lists/* \
 # && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false


FROM nextcloud:stable as main

# Compatibility layer for Video Converter extension
#    (see: https://github.com/PaulLereverend/NextcloudVideo_Converter)
# Binaries from: https://hub.docker.com/r/mwader/static-ffmpeg
COPY --from=mwader/static-ffmpeg:4.3.1-1 /ffmpeg /usr/local/bin/
# @Note: you can copy all that binaries in one layer, but if they
#        are used for different things, it's better to add them separately.
#        As practial tests show, adding 2 more COPY layers result in <0Mb
#        difference (if any) for result image (specifically "virtual" memory)
# COPY --from=mwader/static-ffmpeg:4.3.1-1 /ffprobe /usr/local/bin/
# COPY --from=mwader/static-ffmpeg:4.3.1-1 /qt-faststart /usr/local/bin/

# Compatibility layer for PDF Compression extension
#    (see: #TODO)
COPY --from=pdftron-builder /pdftron/PDFNetWrappers/PDFNetC/Lib /pdftron
RUN mkdir -p /usr/local/lib/php/extensions/no-debug-non-zts-20190902 \
 && cp /pdftron/PDFNetPHP.so /usr/local/lib/php/extensions/no-debug-non-zts-20190902/PDFNetPHP.so
# RUN chmod +x /pdftron/PDFNetPHP.so
COPY php.ini /usr/local/etc/php/php.ini

# Compatibility layer for ocDownloader (direct download extension)
#    (see: https://github.com/e-alfred/ocdownloader)
# Installation: https://github.com/ytdl-org/youtube-dl#installation
RUN curl -Lo /usr/local/bin/youtube-dl https://yt-dl.org/downloads/latest/youtube-dl \
 && chmod a+rx /usr/local/bin/youtube-dl \
 # Installing python3 interpreter for youtube-dl
 && apt-get update \
 && apt-get install -y --no-install-recommends python3 \
 && update-alternatives --install /usr/bin/python python /usr/bin/python3 1000 \
 && rm -rf /var/lib/apt/lists/* \
 && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false

# Special layer(s) to handle cron job inside docker
#    (see: https://docs.nextcloud.com/server/19/admin_manual/configuration_server/background_jobs_configuration.html)
HEALTHCHECK --interval=5m --timeout=60s \
  CMD curl http://localhost/cron.php || exit 1
