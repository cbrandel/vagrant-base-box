# vagrant-base-box

Simple Centos 8 Vagrant box for local development.
- Virtualbox
- bento/centos-8
- ansible provisioning

Use this as starting point for project specific boxes.

## Configuration
See the default in `provision/default.yml`

To override any settings, add a file `site.yml` in the root directory.

## Provisioning
Main entry file for ansible provisioning is `provision/playbook.yml`

## Resources
With ideas and code from:
- https://github.com/roots/trellis
- https://github.com/vccw-team/vccw
