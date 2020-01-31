ARG TAG
FROM ceph/daemon:$TAG

# Change the UID and GID of the Ceph user/group from 167 to 64045.
RUN usermod -u 64045 ceph
RUN groupmod -g 64045 ceph

# Adjust the permissions of all files and directories accordingly.
RUN find / -path /proc -prune -o -group 167 -exec chgrp -h ceph {} \;
RUN find / -path /proc -prune -o -user 167 -exec chown -h ceph {} \;

LABEL "org.opencontainers.image.documentation"="https://docs.osism.io" \
      "org.opencontainers.image.licenses"="ASL 2.0" \
      "org.opencontainers.image.source"="https://github.com/osism/docker-ceph-container" \
      "org.opencontainers.image.url"="https://www.osism.de" \
      "org.opencontainers.image.vendor"="Betacloud Solutions GmbH"
