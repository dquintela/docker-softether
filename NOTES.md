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

# Cross-Arch docker build

https://resin.io/blog/building-arm-containers-on-any-x86-machine-even-dockerhub/
http://blog.ubergarm.com/run-arm-docker-images-on-x86_64-hosts/
http://blog.ubergarm.com/travisci-docker-armhf-images/

Prepare devel machine (since it's a i386, I also need qemu-x86_64-static):
sudo apt-get update
sudo apt-get install -y --no-install-recommends qemu-user-static binfmt-support
update-binfmts --display qemu-arm
update-binfmts --display qemu-x86_64

root@fire:~# qemu-
qemu-aarch64-static       qemu-mips64el-static      qemu-ppc-static
qemu-alpha-static         qemu-mips64-static        qemu-s390x-static
qemu-armeb-static         qemu-mipsel-static        qemu-sh4eb-static
qemu-arm-static           qemu-mipsn32el-static     qemu-sh4-static
qemu-cris-static          qemu-mipsn32-static       qemu-sparc32plus-static
qemu-debootstrap          qemu-mips-static          qemu-sparc64-static
qemu-i386-static          qemu-or32-static          qemu-sparc-static
qemu-m68k-static          qemu-ppc64abi32-static    qemu-tilegx-static
qemu-microblazeel-static  qemu-ppc64le-static       qemu-unicore32-static
qemu-microblaze-static    qemu-ppc64-static         qemu-x86_64-static

root@fire:~# which qemu-arm-static qemu-x86_64-static
/usr/bin/qemu-arm-static
/usr/bin/qemu-x86_64-static

