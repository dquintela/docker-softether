sudo docker run -it --rm dquintela/i386-softether
sudo docker build -t dquintela/i386-softether .
sudo docker run -it --rm -v /sys/fs/cgroup:/sys/fs/cgroup:ro dquintela/i386-softether

teste
# exec - forward signals
exec /lib/systemd/systemd --system --unit=basic.target

# SystemD inside docker
https://hub.docker.com/_/centos/

https://unix.stackexchange.com/questions/146756/forward-sigterm-to-child-in-bash
http://stackoverflow.com/questions/1058047/wait-for-any-process-to-finish
https://stackoverflow.com/questions/36545105/docker-couldnt-find-an-alternative-telinit-implementation-to-spawn

#Other images (ideas)
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
# To detach the tty without exiting the shell,
# use the escape sequence Ctrl-p + Ctrl-q
# note: This will continue to exist in a stopped state once exited (see "docker ps -a")

# Reactach (sudo docker ps)
sudo docker attach silly_rosalind

# Running process (ex: bash) in running container
sudo docker exec -ti silly_rosalind bash

