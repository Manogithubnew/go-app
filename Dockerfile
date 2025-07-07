# ---------- Build stage ----------
FROM golang:1.20 as builder

WORKDIR /app
COPY . .

# Build the Go app binary
RUN go build -o goapp

# ---------- Final runtime image ----------
FROM alpine:latest

# Install CA certificates (optional but recommended if app makes HTTPS requests)
RUN apk --no-cache add ca-certificates

WORKDIR /root/

# Copy the built binary from the builder stage
COPY --from=builder /app/goapp .

# Expose the port your app listens on
EXPOSE 8082

# Set the default port (optional, but helpful if your app reads PORT env var)
ENV PORT=8082

# Run the app
CMD ["./goapp"]
