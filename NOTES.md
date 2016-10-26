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

See also https://github.com/multiarch/ubuntu-core
https://github.com/multiarch/qemu-user-static

Prepare devel machine (since it's a i386, I also need qemu-x86_64-static):
sudo apt-get update
sudo apt-get install -y --no-install-recommends qemu-user-static binfmt-support
update-binfmts --enable qemu-arm
update-binfmts --enable qemu-x86_64
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

https://forums.gentoo.org/viewtopic-p-7657602.html?sid=cacff4eef9be6a37c9c12934a83d760e#7657602
https://github.com/multiarch/qemu-user-static/blob/master/register/register.sh
http://seeblog.seenet.ca/2016/03/running-amd64-binaries-on-an-i386-linux-system/

sudo update-binfmts \
    --package qemu-user-static \
    --install qemu-x86_64 /usr/bin/qemu-x86_64-static \
    --magic '\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x3e\x00' \
    --mask '\xff\xff\xff\xff\xff\xfe\xfe\xfc\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff' \
    --offset 0 \
    --credential yes

WORKS BUTS IT SEEMS TO IT
	https://bugs.launchpad.net/qemu/+bug/1591611 (Fixed ? on >= 2.6.94) [i386 DEVEL IS 2.5.0]
	
 ---> Running in f5e3fa5bddd0
warning: TCG doesn't support requested feature: CPUID.01H:ECX.vmx [bit 5]
+ apt-get update
warning: TCG doesn't support requested feature: CPUID.01H:ECX.vmx [bit 5]
warning: TCG doesn't support requested feature: CPUID.01H:ECX.vmx [bit 5]
E: Method /usr/lib/apt/methods/http did not start correctly
E: Method /usr/lib/apt/methods/http did not start correctly
E: Select has failed - select (14: Bad address)
E: dpkg was interrupted, you must manually run 'dpkg --configure -a' to correct the problem.
setup_frame: not implemented
The command '/bin/sh -c set -xe && apt-get update && apt-get install -q -y --no-.....

	
	--------------
echo ':x86_64:M::\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x3e\x00:\xff\xff\xff\xff\xff\xfe\xfe\xff\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff:/usr/bin/qemu-x86_64-static:P' > /proc/sys/fs/binfmt_misc/register 

WORKS
dquintela@fire:~/docker-softether$ uname -a
Linux fire 4.4.0-45-generic #66-Ubuntu SMP Wed Oct 19 14:12:05 UTC 2016 i686 i686 i686 GNU/Linux
dquintela@fire:~/docker-softether$ ./busybox-x86_64 uname -a
warning: TCG doesn't support requested feature: CPUID.01H:ECX.vmx [bit 5]
Linux fire 4.4.0-45-generic #66-Ubuntu SMP Wed Oct 19 14:12:05 UTC 2016 x86_64 GNU/Linux

BUT on docker build (review later)
Step 10 : RUN apt-get update
---> Running in 9b2166f2bd21
warning: TCG doesn't support requested feature: CPUID.01H:ECX.vmx [bit 5]
/bin/sh: 3: /bin/sh: Syntax error: end of file unexpected (expecting ")")
The command '/bin/sh -c apt-get update' returned a non-zero code: 2
Makefile:45: recipe for target 'container-amd64' failed
make: *** [container-amd64] Error 2


BUT!