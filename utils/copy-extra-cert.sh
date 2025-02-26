#!/bin/bash
# Helper script to copy extra certificate if available

EXTRA_CERT=$1

if [ "$EXTRA_CERT" = "true" ] && [ -f /extra-ca-bundle.pem ]; then
    echo "Adding extra certificate to trust store"
    cp /extra-ca-bundle.pem /etc/pki/ca-trust/source/anchors/extra-ca-bundle.pem
    chmod 644 /etc/pki/ca-trust/source/anchors/extra-ca-bundle.pem
    echo "Extra certificate added with proper permissions"
else
    echo "No extra certificate to add"
fi
