FROM alpine:3.8
RUN apk add --update --no-cache bash curl git
WORKDIR /
COPY github-backup.sh /github-backup.sh
RUN chmod 755 /github-backup.sh
ENTRYPOINT ["/github-backup.sh", "/backup"]
