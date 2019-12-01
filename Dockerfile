ARG TAG
FROM ceph/daemon:$TAG

LABEL maintainer="Betacloud Solutions GmbH (https://www.betacloud-solutions.de)"

# Change the UID and GID of the Ceph user/group from 167 to 64045.
RUN usermod -u 64045 ceph
RUN groupmod -g 64045 ceph

# Adjust the permissions of all files and directories accordingly.
RUN find / -path /proc -prune -o -group 167 -exec chgrp -h ceph {} \;
RUN find / -path /proc -prune -o -user 167 -exec chown -h ceph {} \;
