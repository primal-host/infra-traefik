# Build Traefik from source
FROM golang:latest AS builder

RUN apt-get update && apt-get install -y git make && rm -rf /var/lib/apt/lists/*

WORKDIR /build

# Clone specific version tag
RUN git clone --depth 1 --branch v3.3.3 https://github.com/traefik/traefik.git .

# Generate and build
RUN go generate
RUN CGO_ENABLED=0 go build -o traefik ./cmd/traefik

# Runtime image
FROM ubuntu:latest

RUN apt-get update && apt-get install -y ca-certificates tzdata && rm -rf /var/lib/apt/lists/*

COPY --from=builder /build/traefik /usr/local/bin/traefik

EXPOSE 80 443

ENTRYPOINT ["/usr/local/bin/traefik"]
