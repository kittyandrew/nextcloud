FROM nextcloud:apache

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
 # Compatibility layer for Video Converter Extension
 #    (see: https://github.com/PaulLereverend/NextcloudVideo_Converter)
 ffmpeg \
 # Compatibility layer for PDF Compression Extension (#TODO)
 # TODO
 \
 # Clean up
 && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
 && rm -rf /var/lib/apt/lists/* \
 && apt-get clean

# Special layer(s) to handle cron job inside docker
#    (see: https://docs.nextcloud.com/server/19/admin_manual/configuration_server/background_jobs_configuration.html)
HEALTHCHECK --interval=5m --timeout=60s \
  CMD curl http://localhost/cron.php || exit 1
