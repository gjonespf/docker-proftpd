FROM ubuntu

RUN apt-get update -y && apt-get install -y sudo proftpd

COPY launch /launch
COPY proftpd.conf /etc/proftpd/proftpd.conf 
RUN sudo chown root:root /etc/proftpd/proftpd.conf
RUN mkdir /ftp

ENV PROFTPD_SERVERNAME proftpd
ENV PROFTPD_RUNASUSER root
ENV PROFTPD_UID 1000
ENV PROFTPD_PASSIVE_MIN 4999
ENV PROFTPD_PASSIVE_MAX 50000
ENV PROFTPD_DEFAULT_ADDR 0.0.0.0

EXPOSE 21
EXPOSE 20

ENTRYPOINT /launch
