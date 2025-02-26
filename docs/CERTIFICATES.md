# Certificate Options in ComplianceAsCode Builder

This document explains the certificate options available in the ComplianceAsCode builder and when to use each one.

## Certificate Types

The builder supports two different certificate options:

1. **Primary CA Certificate** (`--cert`)
2. **Extra Organization Certificate** (`--extra-cert`)

## Primary CA Certificate (`--cert`)

The primary CA certificate is the main certificate bundle that enables secure connections to GitHub and other services. This is the certificate that:

- Gets installed in the standard CA trust store location
- Enables git operations to work over HTTPS
- Allows package managers and other tools to function with TLS

By default, this is the MITRE CA bundle located at `./mitre-ca-bundle.pem` in the project root. You can specify a different one with:

```bash
./setup.sh --cert /path/to/primary-ca-bundle.pem
```

**When to use a custom primary certificate:**

- You're in a different organization that uses its own CA
- You're working in an environment with a custom PKI infrastructure
- You need to replace the MITRE certificate with another trusted bundle

## Extra Organization Certificate (`--extra-cert`)

The extra certificate option allows you to add an additional organization-specific certificate without replacing the primary one. This is useful when:

- You need to connect to internal services that use a different CA
- You're working across organizations with different certificate authorities
- You need specialized certificates for specific compliance testing targets

```bash
./setup.sh --extra-cert /path/to/organization-specific-cert.pem
```

**When to use an extra certificate:**

- You need to connect to both MITRE resources AND another organization's resources
- You're testing compliance for systems that use a specific CA
- You need to add specialized certificates for testing scenarios

## Example Scenarios

### Scenario 1: Default MITRE Environment

```bash
./setup.sh
```

This uses the MITRE CA bundle at the default location (`./mitre-ca-bundle.pem`).

### Scenario 2: Different Organization

```bash
./setup.sh --cert /path/to/company-ca-bundle.pem
```

This replaces the MITRE certificate with your organization's CA bundle.

### Scenario 3: Cross-Organization Testing

```bash
./setup.sh --extra-cert /path/to/partner-org-cert.pem
```

This keeps the MITRE certificate as primary but adds another organization's certificate for additional connectivity.

### Scenario 4: Custom Environment with Multiple Certificates

```bash
./setup.sh --cert /path/to/custom-primary.pem --extra-cert /path/to/additional-cert.pem
```

This sets up a completely custom certificate environment.

## Technical Implementation

1. The primary certificate (`--cert`) is copied to the container's main CA trust store
2. The extra certificate (`--extra-cert`) is added to the trust store as an additional certificate
3. Both certificates are then integrated into the container's certificate authority bundle
