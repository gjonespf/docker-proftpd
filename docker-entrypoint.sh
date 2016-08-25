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

mkdir /etc/ftpd

#Try using ftpasswd instead of other yuckness
echo $PASSWORD | ftpasswd --passwd --file=/etc/ftpd/passwd --name=$USERNAME --uid=$OVERRIDEUID --home=/ftp \
    --shell=/bin/false --stdin

#if ! id "$USERNAME" >/dev/null 2>&1; then
#    useradd --shell /bin/sh -u $OVERRIDEUID --create-home --password $PASSWORD $USERNAME 2> /dev/null
#fi

#Make sure user has same UID as mount point (note this won't work if not using a custom ID)
# usermod -u $OVERRIDEUID $USERNAME 2> /dev/null && {
#       groupmod -g $OVERRIDEGID $USERNAME 2> /dev/null || usermod -a -G $OVERRIDEGID $USERNAME
#     }

#Hopefully shouldnt need this now
if [ -n "$PROFTPD_CHOWN" ]; then
    chown -R $USERNAME:$USERNAME /ftp
fi

exec proftpd --nodaemon
