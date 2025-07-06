# Build stage
FROM golang:1.20 as builder
WORKDIR /app
COPY . .
RUN go build -o goapp

# Final image
FROM alpine:latest
WORKDIR /root/
COPY --from=builder /app/goapp .
EXPOSE 8080
CMD ["./goapp"]
