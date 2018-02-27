FROM alpine:latest
MAINTAINER David.Nikdel@gmail.com

# install rsync
RUN apk --no-cache add rsync

# set up default environment (expect this to be overridden)
ENV RSYNC_HOST=localhost
ENV RSYNC_PATH=/app

# copy the puller script
WORKDIR /app
COPY ./main.sh .
RUN chmod +x ./main.sh
ENTRYPOINT [ "/app/main.sh" ]

# expose the /data dir as a volume
VOLUME [ "/data" ]
