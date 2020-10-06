FROM nextcloud:apache

RUN apt-get update \
 && apt-get install -y \
 # Compatibility layer for Video Converter Extension
 #    (see: https://github.com/PaulLereverend/NextcloudVideo_Converter)
 ffmpeg
 # Compatibility layer for PDF Compression Extension (#TODO)
 # TODO

# Clean up
RUN apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
 && rm -rf /var/lib/apt/lists/*
