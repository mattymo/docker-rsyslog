FROM centos

MAINTAINER Aleksandr Didenko adidenko@mirantis.com

WORKDIR /root

RUN rm -rf /etc/yum.repos.d/*
RUN echo -e "[nailgun]\nname=Nailgun Local Repo\nbaseurl=http://10.20.0.2:8080/centos/fuelweb/x86_64/\ngpgcheck=0" > /etc/yum.repos.d/nailgun.repo
RUN yum clean all
RUN yum --quiet install -y puppet rsyslog anacron passwd supervisor
#RUN yum --quiet install -y findutils

ADD start.sh /usr/local/bin/start.sh
ADD astute.yaml /etc/astute.yaml
ADD site.pp /root/site.pp
ADD supervisord.conf /etc/supervisord.conf

# let's disable some services and commands since we don't need them in our container
RUN echo -e '#!/bin/bash\n#chkconfig: 345 20 80\nexit 0' > /etc/init.d/iptables
RUN echo -e '#!/bin/bash\n#chkconfig: 345 20 80\nexit 0' > /sbin/iptables
RUN echo -e '#!/bin/bash\n#chkconfig: 345 20 80\nexit 0' > /etc/init.d/rsyslog

# we need a password for root in order to run crond
RUN echo O9niixOT9LE4zQYp | passwd root --stdin
# we also need to disable pam_loginuid.so for crond in order to run it inside container
RUN sed '/pam_loginuid.so/s/^/#/g' -i /etc/pam.d/crond

RUN chmod +x /etc/init.d/iptables /sbin/iptables /etc/init.d/rsyslog
RUN chmod +x /usr/local/bin/start.sh
RUN touch /etc/puppet/hiera.yaml

EXPOSE 514

CMD ["/usr/local/bin/start.sh"]
