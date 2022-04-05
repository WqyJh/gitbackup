FROM alpine:latest

ARG MIRROR

ADD *.sh /
    
RUN if [[ ! -z "$MIRROR" ]] ; then sed -i "s/dl-cdn.alpinelinux.org/$MIRROR/g" /etc/apk/repositories; fi && \
    apk add --no-cache openssh-client git rsync

VOLUME [ "/data" ]
VOLUME [ "/config" ]

CMD ["/entry-point.sh"]
