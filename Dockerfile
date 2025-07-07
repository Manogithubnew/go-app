# ---------- Build stage ----------
FROM golang:1.23 AS builder
WORKDIR /app
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o goapp .

# ---------- Runtime stage ----------
FROM alpine:latest
RUN apk --no-cache add ca-certificates

WORKDIR /app
COPY --from=builder /app/goapp .
RUN chmod +x /app/goapp

EXPOSE 8082
CMD ["/app/goapp"]
