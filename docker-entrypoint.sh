#!/bin/bash -e

echo Setting credentials to $USERNAME:$PASSWORD
PASSWORD=$(perl -e 'print crypt($ARGV[0], "password")' $PASSWORD)

#Take current UID/GID
MOUNTUID=$(stat -c '%u' "/ftp")
MOUNTGID=$(stat -c '%g' "/ftp")

if [ -n "$PROFTPD_UID" ]; then
    useradd --shell /bin/sh -u $PROFTPD_UID --create-home --password $PASSWORD $USERNAME
else
    useradd --shell /bin/sh -u $MOUNTUID --create-home --password $PASSWORD $USERNAME
fi

if [ -n "$PROFTPD_CHOWN" ]; then
    chown -R $USERNAME:$USERNAME /ftp
fi

exec proftpd --nodaemon
