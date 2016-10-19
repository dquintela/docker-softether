sudo docker run -it --rm dquintela/i386-softether
sudo docker build -t dquintela/i386-softether .
sudo docker run -it --rm -v /sys/fs/cgroup:/sys/fs/cgroup:ro dquintela/i386-softether

teste
# exec - forward signals
exec /lib/systemd/systemd --system --unit=basic.target

# SystemD inside docker
https://hub.docker.com/_/centos/

https://unix.stackexchange.com/questions/146756/forward-sigterm-to-child-in-bash
https://stackoverflow.com/questions/36545105/docker-couldnt-find-an-alternative-telinit-implementation-to-spawn


