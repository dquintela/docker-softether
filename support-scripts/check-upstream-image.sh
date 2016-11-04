https://github.com/docker/docker-py
https://stackoverflow.com/questions/2472552/python-way-to-clone-a-git-repository
https://www.dulwich.io/
https://github.com/gitpython-developers/GitPython

docker inspect --type=image --format "{{range .RepoDigests}}{{.}}{{end}}" dquintela/softether-rpi
docker pull dquintela/softether-rpi
docker inspect --type=image --format "{{range .RepoDigests}}{{.}}{{end}}" dquintela/softether-rpi


dquintela@fire:~/docker-softether$ docker inspect --type=image --format "{{range .RepoDigests}}{{.}}{{end}}" dquintela/softether-rpi

dquintela@fire:~/docker-softether$ docker pull dquintela/softether-rpi
Using default tag: latest
latest: Pulling from dquintela/softether-rpi
40843b8c9eb7: Pull complete
72d732da7426: Pull complete
4bb4f62b0bb2: Pull complete
29f7b256cba8: Pull complete
a3ed95caeb02: Pull complete
a59302ead9d8: Pull complete
fab0c229cbac: Pull complete
bfc0b300d5d3: Pull complete
92355ffb22cb: Pull complete
dc5ab6507406: Pull complete
b08f5c560fa8: Pull complete
dcd05952fbc8: Pull complete
Digest: sha256:c6145c6bf64fd975a96a9dd448149495fa0a0c55aff94501d0a1d16299c8d0a2
Status: Downloaded newer image for dquintela/softether-rpi:latest
dquintela@fire:~/docker-softether$ docker inspect --type=image --format "{{range .RepoDigests}}{{.}}{{end}}" dquintela/softether-rpi
dquintela/softether-rpi@sha256:c6145c6bf64fd975a96a9dd448149495fa0a0c55aff94501d0a1d16299c8d0a2
dquintela@fire:~/docker-softether$




# Auto update running container
https://github.com/CenturyLinkLabs/watchtower
https://stackoverflow.com/questions/26423515/how-to-automatically-update-your-docker-containers-if-base-images-are-updated