# ---------- Build stage ----------
FROM golang:1.23 AS builder
LABEL app="goapp"
WORKDIR /app
COPY . .

# Create user/group
RUN addgroup --gid 2007 cet \
    && adduser --uid 2234 --disabled-password --gecos "" --home /app --ingroup cet cetjobs

# Build statically
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o goapp .

# ---------- Runtime stage ----------
FROM alpine:latest
RUN apk --no-cache add ca-certificates

# Create user/group in runtime image
RUN addgroup -S -g 2007 cet && \
    adduser -S -D -u 2234 -s /sbin/nologin -h /app -G cet cetjobs

WORKDIR /app
COPY --from=builder /app/goapp .

USER cetjobs

EXPOSE 8082
ENTRYPOINT ["/app/goapp", "--logtostderr=true"]
