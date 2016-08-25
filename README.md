Based on andrewvos/docker-proftpd with some customisations for pulling in environment vars.

    docker pull gavinjonespf/docker-proftpd
    docker run -p 21:21 -p 20:20 -e USERNAME=username -e PASSWORD=password -v `pwd`/ftp:/ftp gavinjonespf/docker-proftpd

    ftp -p localhost 21
    Name (0.0.0.0:andrew): username
    Password:
    ftp> ls

Passive mode will require net=host on cmd / network_mode=host in compose to give the correct external IP address.
Note: if you use boot2docker on Mac OSX, be sure to connect to the VM when testing like,

`ftp -p $(boot2docker ip) 21`.
