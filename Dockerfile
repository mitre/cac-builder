# Base image for ComplianceAsCode
FROM fedora:latest

# Build arguments
ARG BUILD_TYPE=full
ARG EXTRA_CERT=false

# Install dependencies
RUN dnf -y update && \
    dnf -y install cmake make openscap-utils python3-pyyaml python3-jinja2 python3-pytest \
    git expat openscap openscap-devel libxml2 libxslt xmlsec1 xmlsec1-openssl \
    python3-setuptools python3-pip python3-lxml python3-requests ca-certificates \
    && dnf clean all

# Install additional Python dependencies
RUN pip3 install pytest-cov

# Create directory for custom certificates
RUN mkdir -p /etc/pki/ca-trust/source/anchors/

# Copy MITRE CA bundle for SSL verification
COPY certs/org/mitre-ca-bundle.pem /etc/pki/ca-trust/source/anchors/mitre-ca-bundle.pem

# Handle extra certificates if specified
COPY ./utils/copy-extra-cert.sh /tmp/copy-extra-cert.sh
RUN chmod +x /tmp/copy-extra-cert.sh && /tmp/copy-extra-cert.sh $EXTRA_CERT

# Update CA store with all certificates
RUN update-ca-trust

# Set up working directory
WORKDIR /content

# Clone the repository with latest content
RUN git clone https://github.com/ComplianceAsCode/content.git /content && \
    # Initialize all submodules
    git submodule update --init --recursive && \
    # Update all submodules to their latest versions
    git submodule update --remote --recursive

# Handle different build types
RUN mkdir -p build && \
    cd build && \
    cmake .. && \
    if [ "$BUILD_TYPE" = "full" ]; then \
    echo "Building full products..." && \
    make -j$(nproc) rhel10 ubuntu2404; \
    else \
    echo "Minimal build - products will be built on demand"; \
    fi

# Add helper scripts
COPY ./utils/build-product.sh /usr/local/bin/build-product
COPY ./utils/init-environment.sh /usr/local/bin/init-environment
COPY ./utils/build-common-products.sh /usr/local/bin/build-common-products
RUN chmod +x /usr/local/bin/build-product /usr/local/bin/init-environment /usr/local/bin/build-common-products

# Add a welcome message
COPY ./utils/welcome.sh /etc/profile.d/welcome.sh
RUN chmod +x /etc/profile.d/welcome.sh

ENTRYPOINT ["/bin/bash"]
