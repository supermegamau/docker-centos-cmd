FROM       centos:8

RUN yum update -y && \
    yum install -y openssh-server && \
    yum clean all
    
RUN mkdir /var/run/sshd

RUN sed -ri 's/^#PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

RUN ssh-keygen -q -t rsa -b 2048 -f /etc/ssh/ssh_host_rsa_key -N ''
RUN ssh-keygen -q -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N ''
RUN ssh-keygen -t dsa -f /etc/ssh/ssh_host_ed25519_key  -N ''

RUN echo -e '#!/bin/bash\n/usr/sbin/sshd -D &\n/bin/bash' > /usr/sbin/start.sh
RUN chmod +x /usr/sbin/start.sh

EXPOSE 22

CMD ["/bin/bash", "/usr/sbin/start.sh"]
