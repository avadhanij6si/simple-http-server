# This file is copied from: https://github.com/k4yt3x/simple-http-server/blob/master/Dockerfile
# LICENS: BSD 2-Clause "Simplified" License
#    please see https://github.com/k4yt3x/simple-http-server/blob/master/LICENSE for more details

FROM rust:1.61-alpine3.15 as builder
# branch name or tag
COPY . /simple-http-server
RUN apk add --no-cache --virtual .build-deps make musl-dev openssl-dev perl pkgconfig \
    && ls \
    && RUSTFLAGS='-C link-arg=-s' cargo build \
    --features only-openssl \
    --no-default-features \
    --release \
    --target x86_64-unknown-linux-musl \
    --manifest-path=/simple-http-server/Cargo.toml

FROM gcr.io/distroless/static:nonroot
LABEL maintainer="avadhanij6si" \
    org.opencontainers.image.source="https://github.com/avadhanij6si/simple-http-server" \
    org.opencontainers.image.description="A minimal distroless container image for simple-http-server. A rust based
    http server"
COPY --from=builder \
    /simple-http-server/target/x86_64-unknown-linux-musl/release/simple-http-server \
    /usr/local/bin/simple-http-server
USER nonroot:nonroot
WORKDIR /var/www/html
ENTRYPOINT ["/usr/local/bin/simple-http-server"]
