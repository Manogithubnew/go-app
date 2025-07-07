# ---------- Build stage ----------
FROM golang:1.23 as builder

WORKDIR /app
COPY . .

# Build statically linked binary
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -o goapp

# ---------- Final runtime image ----------
FROM alpine:latest

# Install CA certificates (optional)
RUN apk --no-cache add ca-certificates

WORKDIR /root/

# Copy the statically built binary
COPY --from=builder /app/goapp .

EXPOSE 8082
ENV PORT=8082

CMD ["./goapp"]
