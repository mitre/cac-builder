#!/bin/bash
# Helper script to copy extra certificate if available

EXTRA_CERT=$1

if [ "$EXTRA_CERT" = "true" ] && [ -f /extra-ca-bundle.pem ]; then
    echo "Adding extra certificate to trust store"
    cp /extra-ca-bundle.pem /etc/pki/ca-trust/source/anchors/
else
    echo "No extra certificate to add"
fi
