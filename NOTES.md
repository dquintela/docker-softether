# Todo

	makefile
		https://stackoverflow.com/questions/26118303/docker-with-make-build-image-on-dockerfile-change
		https://github.com/thockin/go-build-template
	getopts
	imagem gerada com docker build-arg com git describe
		https://github.com/thockin/go-build-template/blob/master/Makefile
	subimagem -> vpnserver
	cross-build -> qemu (amd64 + armel?)

# Helper commands

sudo docker run -it --rm dquintela/softether-i386

sudo docker build -t dquintela/softether-i386 .

sudo docker run -it --rm dquintela/softether-i386

sudo docker run -it --rm --cap-add NET_ADMIN --name softether-i386 dquintela/softether-i386 vpnserver

sudo docker run -it --rm --cap-add NET_ADMIN -v /home/dquintela/vpnserver/vpn_server.config:/usr/local/softether/vpnserver/vpn_server.config --name softether-i386 dquintela/softether-i386 vpnserver

sudo docker exec -ti softether-i386 bash
    
     # Install ip, ifconfig and ssh to test inside attached image
     apt-get update && apt-get install iproute2 net-tools ssh-client

# Random notes

exec - forward signals

exec /lib/systemd/systemd --system --unit=basic.target

# SystemD inside docker
https://hub.docker.com/_/centos/

https://unix.stackexchange.com/questions/146756/forward-sigterm-to-child-in-bash

http://stackoverflow.com/questions/1058047/wait-for-any-process-to-finish

https://stackoverflow.com/questions/36545105/docker-couldnt-find-an-alternative-telinit-implementation-to-spawn

# Other images (ideas)

https://github.com/cnf/docker-softether

https://github.com/jpillora/docker-vpn

https://github.com/cveira/docker-vnet-softether

https://github.com/jameskorospencer/docker-softether-client

https://github.com/Dmitriusan/docker-softether-vpn-client

https://github.com/k0sk/docker-softether-digitalocean

https://github.com/xiaoyawl/docker-softethervpn

https://github.com/TeamWiizmi/docker-compose-softethervpn

# Detach container

Type Ctrl+p, Ctrl+q will help you to turn interactive mode to daemon mode
See https://docs.docker.com/articles/basics/#running-an-interactive-shell

>> To detach the tty without exiting the shell,
>> use the escape sequence Ctrl-p + Ctrl-q
>> note: This will continue to exist in a stopped state once exited (see "docker ps -a")

# Reattach (sudo docker ps)

sudo docker attach silly_rosalind

# Running process (ex: bash) in running container

sudo docker exec -ti silly_rosalind bash

