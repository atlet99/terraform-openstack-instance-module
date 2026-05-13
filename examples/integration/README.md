# Integration Example

This example demonstrates a reusable chain of modules:

1. `network-module` creates network/subnet/router.
2. `security-group-module` creates a security group.
3. `instance-module` creates a VM and attaches a primary boot port.
4. `volume-module` creates and attaches an extra data volume.

Use this example as a compatibility smoke-check for module interfaces and outputs.
