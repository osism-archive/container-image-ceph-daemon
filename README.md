# docker-image-ceph-container

[![Quay](https://img.shields.io/badge/Quay-osism%2Fceph--daemon-blue.svg)](https://quay.io/repository/osism/ceph-daemon)

Ubuntu images have not been provided by the [ceph/ceph-container](https://github.com/ceph/ceph-container)
upstream since the end of August 2018.

This image is a workaround to seamlessly migrate environments running on
Ubuntu images to CentOS images. [ceph/daemon](https://hub.docker.com/r/ceph/daemon/)
is used as the basis for this container.

Due to this workaround, it is not necessary to adjust the existing file
permissions of ``/var/lib/ceph`` during the rolling update.

To use this container it is necessary to always set the ``ceph_uid`` fact in
``ceph-ansible`` to ``64045``.
