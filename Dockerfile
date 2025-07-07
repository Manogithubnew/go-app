FROM golang:1.22
LABEL app='goapp'
LABEL TEM_NAME='Conatiner Team'

COPY . .

USER root

RUN go version

WORKDIR /app

RUN addgroup -S -g 2007 cet \
    && adduser -S -D -u 2234 -s /sbin/nologin -h /app -G cet cetjobs \
    && chown -R 2234:2007 /app

RUN apk update && apk add --no-cache bash

COPY . .
USER cetjobs

EXPOSE 8082

RUN go build -o goapp

ENTRYPOINT ["/app/goapp","--logtostderr=true"]

