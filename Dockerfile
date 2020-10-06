FROM nextcloud:apache

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
 # Compatibility layer for Video Converter Extension
 #    (see: https://github.com/PaulLereverend/NextcloudVideo_Converter)
 ffmpeg \
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
 && rm -rf Build \
 \
 # Clean up
 && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    wget \
    git \
    build-essential \
    cmake \
    swig \
 && rm -rf /var/lib/apt/lists/* \
 && apt-get clean

# Special layer(s) to handle cron job inside docker
#    (see: https://docs.nextcloud.com/server/19/admin_manual/configuration_server/background_jobs_configuration.html)
HEALTHCHECK --interval=5m --timeout=60s \
  CMD curl http://localhost/cron.php || exit 1
