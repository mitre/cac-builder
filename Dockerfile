# Base image for ComplianceAsCode
FROM fedora:latest

# Build arguments
ARG BUILD_TYPE=full
ARG EXTRA_CERT=false

# Create directory for custom certificates early
RUN mkdir -p /etc/pki/ca-trust/source/anchors/

# Install CA certificates - these are now added via build context with proper permissions
COPY certs/org/ca-bundle.pem /etc/pki/ca-trust/source/anchors/ca-bundle.pem
RUN chmod 644 /etc/pki/ca-trust/source/anchors/ca-bundle.pem

# Handle extra certificates if specified - this is now handled by the build script
# which will create the appropriate files with the right permissions

# Update CA store with all certificates before any network operations
RUN update-ca-trust

# Configure DNF for more reliable package installation in test environments
RUN echo "fastestmirror=true" >> /etc/dnf/dnf.conf && \
    echo "keepcache=true" >> /etc/dnf/dnf.conf && \
    echo "retries=10" >> /etc/dnf/dnf.conf && \
    echo "timeout=120" >> /etc/dnf/dnf.conf

# Now install dependencies after certificates are set up
RUN dnf -y update && \
    dnf -y install --nobest --nogpgcheck cmake make openscap-utils python3-pyyaml python3-jinja2 python3-pytest \
    git expat openscap openscap-devel libxml2 libxslt xmlsec1 xmlsec1-openssl \
    python3-setuptools python3-pip python3-lxml python3-requests ca-certificates \
    && dnf clean all

# Install additional Python dependencies
RUN pip3 install pytest-cov

# Set up working directory
WORKDIR /content

# Configure git to be more tolerant during testing
# This is important when running with ACT which might use self-signed certificates
RUN git config --global http.sslVerify false

# Clone the repository with latest content
# Configure git to use our certificates (now properly installed or SSL verification disabled for testing)
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
