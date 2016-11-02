# Dockerized VPNether VPN Server / Client / Bridge built from source
[![Build Status](https://img.shields.io/travis/dquintela/docker-softether.svg)](https://travis-ci.org/dquintela/docker-softether.svg?branch=master)
[![GitHub tag](https://img.shields.io/github/tag/dquintela/docker-softether.svg)]()
[![GitHub issues](https://img.shields.io/github/issues/dquintela/docker-softether.svg)]()
[![license](https://img.shields.io/github/license/dquintela/docker-softether.svg)]()
[![Docker Pulls](https://img.shields.io/docker/pulls/dquintela/softether-amd64.svg)]()

## Run

WORK IN PROGRESS - DON'T USE

Simplest version:

    docker run -d --net host -P --cap-add NET_ADMIN --name vpnserver dquintela/softether-i386 vpnserver
	
This is start vpnserver with random passwords (see console? how?) and a default configuration that as connectivity with 
docker host only (link to docker network here)

	docker run -d --net host -P --cap-add NET_ADMIN --name vpnbridge dquintela/softether-i386 vpnbridge
	docker start --net host -P --cap-add NET_ADMIN --name vpnbridge dquintela/softether-i386 vpnbridge

This will start vpnbridge that connects to ?

TODO: Example without --net host

Passing configuration:

	touch /home/dquintela/vpnserver/vpn_server.config # If file is not previously existent
	docker run -d -v /home/dquintela/vpnserver/vpn_server.config:/usr/local/softether/vpnserver/vpn_server.config --net host --cap-add NET_ADMIN --name vpnserver dquintela/softether-i386 vpnserver

Passing directory for logs:

	Using volume directory

	mkdir /home/dquintela/vpnserver/logs
	docker run -d -v /home/dquintela/vpnserver/logs:/var/log/softether --net host --cap-add NET_ADMIN --name vpnserver dquintela/softether-i386 vpnserver

	Using docker volume

	docker volume create --name softether-logs
	docker run -d --net host --cap-add NET_ADMIN -v softether-logs:/var/log/vpnserver --name vpnserver dquintela/softether-i386 vpnserver
