# ---------- Build stage ----------
FROM golang:1.23 as builder
WORKDIR /app
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o goapp .

# ---------- Final runtime image ----------
FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=builder /app/goapp .
EXPOSE 8082
ENV PORT=8082
CMD ["./goapp"]
