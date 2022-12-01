FROM ubuntu:22.10 as ansible-ssh-agent:ubuntu_22.10
LABEL name="ansible-ssh-agent:ubuntu_22.10"

# Run everything as root user
USER root

# No interative menu
ENV DEBIAN_FRONTEND noninteractive

# Install base packages
RUN apt-get -y update && \
    apt-get -y upgrade && \
    apt-get -y -qq --no-install-recommends install \
        apt-transport-https \
        python3-pip \
        sudo \
        wget \
        curl \
        git \
        nmap \
        sshpass \
        openssh-server \
    && apt-get -qq clean

# Configure locales
#RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y locales
#RUN sed -i -e 's/# de_DE.UTF-8 UTF-8/de_DE.UTF-8 UTF-8/' /etc/locale.gen
#    && dpkg-reconfigure --frontend=noninteractive locales \
#    && update-locale LANG=de_DE.UTF-8
#ENV LANG de_DE.UTF-8

# Configure sudo.
#RUN ex +"%s/^%sudo.*$/%sudo ALL=(ALL:ALL) NOPASSWD:ALL/g" -scwq! /etc/sudoers

# Setup the default user.
RUN groupadd ansible
RUN useradd -rm -d /home/ansible -s /bin/bash -g ansible ansible
RUN echo 'ansible:ansible' | chpasswd

## Setup ssh directory
RUN mkdir -p /home/ansible/.ssh/
RUN chmod 700 /home/ansible/.ssh/
#COPY files/authorized_keys /home/ansible/.ssh/
#RUN chmod 700 /home/ansible/.ssh/authorized_keys
RUN chown ansible:ansible -R /home/ansible

# Install Ansible
RUN apt remove ansible \
    && apt --purge autoremove \
    && apt -y install software-properties-common \
    && apt-add-repository ppa:ansible/ansible \
    && apt-get -y update \
    && apt install ansible

RUN ansible --version

# Configure SSHD
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
#RUN test -f /etc/ssh/ssh_host_ecdsa_key || /usr/bin/ssh-keygen -q -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -C '' -N ''
#RUN test -f /etc/ssh/ssh_host_rsa_key || /usr/bin/ssh-keygen -q -t rsa -f /etc/ssh/ssh_host_rsa_key -C '' -N ''
#RUN test -f /etc/ssh/ssh_host_ed25519_key || /usr/bin/ssh-keygen -q -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -C '' -N ''
# needs work

RUN RUNLEVEL=1 dpkg-reconfigure openssh-server

# Expose ssh port
EXPOSE 22

# Run ssh daemon
CMD ["/usr/sbin/sshd", "-D"]
