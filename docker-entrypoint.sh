#!/bin/bash -e

echo Setting credentials to $USERNAME:$PASSWORD
PASSWORD=$(perl -e 'print crypt($ARGV[0], "password")' $PASSWORD)

#Take current UID/GID
MOUNTUID=$(stat -c '%u' "/ftp")
MOUNTGID=$(stat -c '%g' "/ftp")

OVERRIDEUID=$MOUNTUID
OVERRIDEGID=$MOUNTGID

if [ -n "$PROFTPD_UID" ]; then
    OVERRIDEUID=$PROFTPD_UID
fi

if ! id "$USERNAME" >/dev/null 2>&1; then
    useradd --shell /bin/sh -u $OVERRIDEUID --create-home --password $PASSWORD $USERNAME
fi

#Make sure user has same UID as mount point
usermod -u $OVERRIDEUID $USERNAME 2> /dev/null && {
      groupmod -g $OVERRIDEGID $USERNAME 2> /dev/null || usermod -a -G $OVERRIDEGID $USERNAME
    }

#Hopefully shouldnt need this now
if [ -n "$PROFTPD_CHOWN" ]; then
    chown -R $USERNAME:$USERNAME /ftp
fi

exec proftpd --nodaemon
