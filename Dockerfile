ARG TAG
FROM ceph/daemon:$TAG

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Change the UID and GID of the Ceph user/group from 167 to 64045.
RUN usermod -u 64045 ceph
RUN groupmod -g 64045 ceph

# Adjust the permissions of all files and directories accordingly.
RUN find / -path /proc -prune -o -group 167 -exec chgrp -h ceph {} \;
RUN find / -path /proc -prune -o -user 167 -exec chown -h ceph {} \;

RUN yum update -y \
    && yum clean all

# Install zabbix-sender package to be able to use /usr/bin/zabbix_sender
RUN centos_version="$(tr -dc '0-9.' < /etc/centos-release | cut -d \. -f1)" \
    && rpm -Uvh "https://repo.zabbix.com/zabbix/5.0/rhel/${centos_version}/x86_64/zabbix-release-5.1-1.el${centos_version}.noarch.rpm" \
    && yum install -y zabbix-sender \
    && yum clean all

LABEL "org.opencontainers.image.documentation"="https://docs.osism.io" \
      "org.opencontainers.image.licenses"="ASL 2.0" \
      "org.opencontainers.image.source"="https://github.com/osism/docker-ceph-container" \
      "org.opencontainers.image.url"="https://www.osism.de" \
      "org.opencontainers.image.vendor"="Betacloud Solutions GmbH"
