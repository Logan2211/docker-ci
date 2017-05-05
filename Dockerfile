FROM ubuntu:16.04

RUN apt-get update && \
    apt-get install -y \
      sudo curl build-essential python2.7 python-dev git-core libffi-dev \
      libssl-dev nano && rm -rf /var/lib/apt/lists/*

# See tozd/ubuntu-systemd
# tweaks for systemd
RUN systemctl mask -- \
    -.mount \
    dev-mqueue.mount \
    dev-hugepages.mount \
    etc-hosts.mount \
    etc-hostname.mount \
    etc-resolv.conf.mount \
    proc-bus.mount \
    proc-irq.mount \
    proc-kcore.mount \
    proc-sys-fs-binfmt_misc.mount \
    proc-sysrq\\\\x2dtrigger.mount \
    sys-fs-fuse-connections.mount \
    sys-kernel-config.mount \
    sys-kernel-debug.mount \
    tmp.mount \
 \
 && systemctl mask -- \
    console-getty.service \
    display-manager.service \
    getty-static.service \
    getty\@tty1.service \
    hwclock-save.service \
    ondemand.service \
    systemd-logind.service \
    systemd-remount-fs.service \
 \
 && ln -sf /lib/systemd/system/multi-user.target /etc/systemd/system/default.target \
 \
 && ln -sf /lib/systemd/system/halt.target /etc/systemd/system/sigpwr.target

# Install pip
RUN curl --silent --show-error --retry 5 \
    https://bootstrap.pypa.io/get-pip.py | sudo python2.7

# Install python packages
RUN pip install ansible ansible-lint tox


RUN useradd -m -G users,sudo ubuntu && \
    echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/90-ubuntu

# Use local apt mirrors
RUN sed -ri 's%(archive|security).ubuntu.com%mirror.lstn.net%' \
    /etc/apt/sources.list

USER ubuntu
