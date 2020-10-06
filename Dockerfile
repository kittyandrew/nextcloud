FROM nextcloud:apache as pdftron-builder
# Building PDFTron
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
 # Build layer for PDF Compression Extension (#TODO)
 # @Important: remove later
 wget git build-essential cmake swig \ 
 \
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
 && cd .. \
 && rm -rf Build


FROM nextcloud:apache as main
# Compatibility layer for Video Converter Extension
#    (see: https://github.com/PaulLereverend/NextcloudVideo_Converter)
# Binaries from: https://hub.docker.com/r/mwader/static-ffmpeg
COPY --from=mwader/static-ffmpeg:4.3.1-1 /ffmpeg /usr/local/bin/
# Compatibility layer for PDF Compression Extension
#    (see: #TODO)
COPY --from=pdftron-builder /pdftron/PDFNetWrappers/PDFNetC/Lib /pdftron
# Special layer(s) to handle cron job inside docker
#    (see: https://docs.nextcloud.com/server/19/admin_manual/configuration_server/background_jobs_configuration.html)
HEALTHCHECK --interval=5m --timeout=60s \
  CMD curl http://localhost/cron.php || exit 1
