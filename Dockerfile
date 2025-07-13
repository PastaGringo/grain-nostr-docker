FROM alpine:latest

# Install dependencies for downloading and extracting releases
RUN apk add --no-cache ca-certificates curl jq unzip tar gzip wget

WORKDIR /tmp

# Detect architecture and download appropriate pre-release
RUN ARCH=$(uname -m) && \
    case $ARCH in \
        x86_64) GRAIN_ARCH="amd64" ;; \
        aarch64) GRAIN_ARCH="arm64" ;; \
        *) echo "Unsupported architecture: $ARCH" && exit 1 ;; \
    esac && \
    echo "Detected architecture: $ARCH -> grain-linux-$GRAIN_ARCH" && \
    PRERELEASE_VERSION=$(curl -s https://api.github.com/repos/0ceanslim/grain/releases | jq -r '.[] | select(.prerelease == true) | .tag_name' | head -n1) && \
    if [ -z "$PRERELEASE_VERSION" ]; then \
        echo "No pre-release found, falling back to latest release" && \
        PRERELEASE_VERSION=$(curl -s https://api.github.com/repos/0ceanslim/grain/releases/latest | jq -r .tag_name); \
    fi && \
    echo "Downloading GRAIN pre-release version: $PRERELEASE_VERSION for linux-$GRAIN_ARCH" && \
    DOWNLOAD_URL="https://github.com/0ceanSlim/grain/releases/download/$PRERELEASE_VERSION/grain-linux-$GRAIN_ARCH.tar.gz" && \
    curl -L "$DOWNLOAD_URL" -o grain-release.tar.gz && \
    echo "Extracting release..." && \
    tar -xzf grain-release.tar.gz && \
    EXTRACTED_DIR=$(tar -tzf grain-release.tar.gz | head -1 | cut -f1 -d"/") && \
    echo "Moving files from $EXTRACTED_DIR to /app..." && \
    mkdir -p /app && \
    mv "$EXTRACTED_DIR"/* /app/ && \
    chmod +x /app/grain && \
    rm -rf /tmp/*

WORKDIR /app

# Create non-root user for security
RUN addgroup -g 1001 grain && \
    adduser -D -s /bin/sh -u 1001 -G grain grain && \
    chown -R grain:grain /app

# Set default environment variables for relay metadata (owner-configurable only)
ENV RELAY_NAME="🌾 GRAIN Relay" \
    RELAY_DESCRIPTION="Go Relay Architecture for Implementing Nostr" \
    RELAY_BANNER="" \
    RELAY_ICON="" \
    RELAY_PUBKEY="" \
    RELAY_CONTACT="" \
    RELAY_PRIVACY_POLICY="" \
    RELAY_TERMS_OF_SERVICE="" \
    RELAY_COUNTRIES="US" \
    RELAY_LANGUAGE_TAGS="en,en-US" \
    RELAY_TAGS="open-access,community" \
    RELAY_POSTING_POLICY="" \
    RELAY_MAX_MESSAGE_LENGTH="524288" \
    RELAY_MAX_CONTENT_LENGTH="8196" \
    RELAY_MAX_SUBSCRIPTIONS="10" \
    RELAY_MAX_LIMIT="500" \
    RELAY_AUTH_REQUIRED="false" \
    RELAY_PAYMENT_REQUIRED="false" \
    RELAY_RESTRICTED_WRITES="false" \
    RELAY_CREATED_AT_LOWER_LIMIT="1577836800" \
    RELAY_CREATED_AT_UPPER_LIMIT="null"

# Copy configuration script
COPY configure-relay.sh /app/configure-relay.sh
RUN chmod +x /app/configure-relay.sh && chown grain:grain /app/configure-relay.sh

USER grain

EXPOSE 8181

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8181/ || exit 1

CMD ["/app/configure-relay.sh"]