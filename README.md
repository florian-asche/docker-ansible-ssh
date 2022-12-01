# Ansible Agent - Docker Container with Ansible and SSHD-Server

![Build/Push (master)](https://github.com/florian-asche/docker-ansible-ssh/workflows/Build/Push%20(master)/badge.svg)

This is docker container with [Ansible](https://www.ansible.com/)' and a ssh-server.
This docker container can be used as ansible agent for example to use it with rundeck.

## Prerequisites

## Installation

### Using Docker

The container is available as a [Docker image](https://hub.docker.com/r/florian9931/docker-ansible-ssh).
You can run it using the following example and pass configuration environment variables:

```bash
$ docker run \
  -v $(pwd)/.ssh/authorized_keys:./path/to/your/authorized_keys \
  -p 22:2022 \
  florian9931/docker-ansible-ssh:latest
```
