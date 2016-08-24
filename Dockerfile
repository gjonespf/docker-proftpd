FROM ubuntu

RUN apt-get update -y
RUN apt-get install -y proftpd

ADD launch /launch
ADD proftpd.conf /etc/proftpd/proftpd.conf
RUN sudo chown root:root /etc/proftpd/proftpd.conf
RUN mkdir /ftp

ENV PROFTPD_SERVERNAME proftpd
ENV PROFTPD_RUNASUSER root
ENV PROFTPD_PASSIVE_MIN 4999
ENV PROFTPD_PASSIVE_MAX 50000

EXPOSE 21
EXPOSE 20

ENTRYPOINT /launch
