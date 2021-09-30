FROM percona/percona-server:5.7
MAINTAINER raptor<raptor.zh@gmail.com>
USER root
RUN yum update -y && yum install -y keepalived
COPY ./my_bin /opt/mysql
USER mysql
