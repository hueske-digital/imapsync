FROM alpine:latest

RUN echo "@community https://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
    && apk add --no-cache imapsync bash curl

COPY sync.sh /usr/local/bin/sync.sh
RUN chmod +x /usr/local/bin/sync.sh

ENV SYNC_INTERVAL=3600

CMD ["/usr/local/bin/sync.sh"]