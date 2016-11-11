# Dockerized SoftEther VPN Server / Client / Bridge 
[![GitHub tag](https://img.shields.io/github/tag/dquintela/docker-softether.svg)]() 
[![GitHub issues](https://img.shields.io/github/issues/dquintela/docker-softether.svg)](https://github.com/dquintela/docker-softether/issues) 
[![license](https://img.shields.io/github/license/dquintela/docker-softether.svg)](https://github.com/dquintela/docker-softether/blob/master/LICENSE) 
[![Build Status](https://img.shields.io/travis/dquintela/docker-softether.svg)](https://travis-ci.org/dquintela/docker-softether)

WORK IN PROGRESS - DON'T USE

This project generates a docker image for the architectures (amd64, i386, armel, rpi, armhf) and two variants (base-image and app-image).

The base-image is built from source with the SoftEther's vpnserver, vpnbridge and vpnclient binaries. 
The especific binary to be run is especified through an run script first argument [see images and examples below].

The app-image extends base-image to simplify that necessity - app-image can use ''docker start'', while base-image must use ''docker run''.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Supported archs:](#supported-archs)
- [Docker](#docker)
- [Run](#run)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Supported archs:
* amd64 - 64 bits, the normal docker image architecture
* i386 - 32 bits, i386 based distro (ex: ubuntu installed on i386 - package docker.io and not docker's repos, since they don't support i386)
* armel - ARMv5 (works with Raspberry Pi 1 (A, B, A+, B+, Zero), but prefer rpi below)
* rpi - ARMv6+VFP2 (armhf rebuilt RPi's ARM variant - Raspberry Pi 1 (A, B, A+, B+, Zero)
* armhf - ARMv7 (compatible with Raspberry Pi 2/3)
* aarch64 - ARMv8 or ARM64

See https://wiki.debian.org/RaspberryPi

## Docker

The images are available on my Docker Hub page https://hub.docker.com/r/dquintela/ and can be used like ''docker pull dquintela/{{image name}}'' or ''docker run dquintela/{{image name}}''

| image \ arch | amd64 | i386 | armel | rpi | armhf | aarch64 |
|---:|:---:|:---:|:---:|:---:|:---:|:---:|
| base-image | softether-amd64 | softether-i386 | softether-armel | softether-rpi | softether-armhf | softether-aarch64 |
| vpnserver | softether-vpnserver-amd64 | softether-vpnserver-i386 | softether-vpnserver-armel | softether-vpnserver-rpi | softether-vpnserver-armhf | softether-vpnserver-aarch64 |
| vpnbridge | softether-vpnbridge-amd64 | softether-vpnbridge-i386 | softether-vpnbridge-armel | softether-vpnbridge-rpi | softether-vpnbridge-armhf | softether-vpnbridge-aarch64 |
| vpnclient | softether-vpnclient-amd64 | softether-vpnclient-i386 | softether-vpnclient-armel | softether-vpnclient-rpi | softether-vpnclient-armhf | softether-vpnclient-aarch64 |

These are the badge statitics for those images.

| Image | Image Size | Image Version | Docker Pulls |
|------:|:-----------:|:----------:|:-------------:|
| dquintela/softether-amd64 | [![Image Size](https://images.microbadger.com/badges/image/dquintela/softether-amd64.svg)](https://microbadger.com/images/dquintela/softether-amd64) | [![Image Version](https://images.microbadger.com/badges/version/dquintela/softether-amd64.svg)](https://microbadger.com/images/dquintela/softether-amd64) | [![Docker Pulls](https://img.shields.io/docker/pulls/dquintela/softether-amd64.svg)](https://hub.docker.com/r/dquintela/softether-amd64) |
| dquintela/softether-vpnserver-amd64 | [![Image Size](https://images.microbadger.com/badges/image/dquintela/softether-vpnserver-amd64.svg)](https://microbadger.com/images/dquintela/softether-vpnserver-amd64) | [![Image Version](https://images.microbadger.com/badges/version/dquintela/softether-vpnserver-amd64.svg)](https://microbadger.com/images/dquintela/softether-vpnserver-amd64) | [![Docker Pulls](https://img.shields.io/docker/pulls/dquintela/softether-vpnserver-amd64.svg)](https://hub.docker.com/r/dquintela/softether-vpnserver-amd64) |
| dquintela/softether-vpnbridge-amd64 | [![Image Size](https://images.microbadger.com/badges/image/dquintela/softether-vpnbridge-amd64.svg)](https://microbadger.com/images/dquintela/softether-vpnbridge-amd64) | [![Image Version](https://images.microbadger.com/badges/version/dquintela/softether-vpnbridge-amd64.svg)](https://microbadger.com/images/dquintela/softether-vpnbridge-amd64) | [![Docker Pulls](https://img.shields.io/docker/pulls/dquintela/softether-vpnbridge-amd64.svg)](https://hub.docker.com/r/dquintela/softether-vpnbridge-amd64) |
| dquintela/softether-vpnclient-amd64 | [![Image Size](https://images.microbadger.com/badges/image/dquintela/softether-vpnclient-amd64.svg)](https://microbadger.com/images/dquintela/softether-vpnclient-amd64) | [![Image Version](https://images.microbadger.com/badges/version/dquintela/softether-vpnclient-amd64.svg)](https://microbadger.com/images/dquintela/softether-vpnclient-amd64) | [![Docker Pulls](https://img.shields.io/docker/pulls/dquintela/softether-vpnclient-amd64.svg)](https://hub.docker.com/r/dquintela/softether-vpnclient-amd64) |
| dquintela/softether-i386 | [![Image Size](https://images.microbadger.com/badges/image/dquintela/softether-i386.svg)](https://microbadger.com/images/dquintela/softether-i386) | [![Image Version](https://images.microbadger.com/badges/version/dquintela/softether-i386.svg)](https://microbadger.com/images/dquintela/softether-i386) | [![Docker Pulls](https://img.shields.io/docker/pulls/dquintela/softether-i386.svg)](https://hub.docker.com/r/dquintela/softether-i386) |
| dquintela/softether-vpnserver-i386 | [![Image Size](https://images.microbadger.com/badges/image/dquintela/softether-vpnserver-i386.svg)](https://microbadger.com/images/dquintela/softether-vpnserver-i386) | [![Image Version](https://images.microbadger.com/badges/version/dquintela/softether-vpnserver-i386.svg)](https://microbadger.com/images/dquintela/softether-vpnserver-i386) | [![Docker Pulls](https://img.shields.io/docker/pulls/dquintela/softether-vpnserver-i386.svg)](https://hub.docker.com/r/dquintela/softether-vpnserver-i386) |
| dquintela/softether-vpnbridge-i386 | [![Image Size](https://images.microbadger.com/badges/image/dquintela/softether-vpnbridge-i386.svg)](https://microbadger.com/images/dquintela/softether-vpnbridge-i386) | [![Image Version](https://images.microbadger.com/badges/version/dquintela/softether-vpnbridge-i386.svg)](https://microbadger.com/images/dquintela/softether-vpnbridge-i386) | [![Docker Pulls](https://img.shields.io/docker/pulls/dquintela/softether-vpnbridge-i386.svg)](https://hub.docker.com/r/dquintela/softether-vpnbridge-i386) |
| dquintela/softether-vpnclient-i386 | [![Image Size](https://images.microbadger.com/badges/image/dquintela/softether-vpnclient-i386.svg)](https://microbadger.com/images/dquintela/softether-vpnclient-i386) | [![Image Version](https://images.microbadger.com/badges/version/dquintela/softether-vpnclient-i386.svg)](https://microbadger.com/images/dquintela/softether-vpnclient-i386) | [![Docker Pulls](https://img.shields.io/docker/pulls/dquintela/softether-vpnclient-i386.svg)](https://hub.docker.com/r/dquintela/softether-vpnclient-i386) |
| dquintela/softether-armel | [![Image Size](https://images.microbadger.com/badges/image/dquintela/softether-armel.svg)](https://microbadger.com/images/dquintela/softether-armel) | [![Image Version](https://images.microbadger.com/badges/version/dquintela/softether-armel.svg)](https://microbadger.com/images/dquintela/softether-armel) | [![Docker Pulls](https://img.shields.io/docker/pulls/dquintela/softether-armel.svg)](https://hub.docker.com/r/dquintela/softether-armel) |
| dquintela/softether-vpnserver-armel | [![Image Size](https://images.microbadger.com/badges/image/dquintela/softether-vpnserver-armel.svg)](https://microbadger.com/images/dquintela/softether-vpnserver-armel) | [![Image Version](https://images.microbadger.com/badges/version/dquintela/softether-vpnserver-armel.svg)](https://microbadger.com/images/dquintela/softether-vpnserver-armel) | [![Docker Pulls](https://img.shields.io/docker/pulls/dquintela/softether-vpnserver-armel.svg)](https://hub.docker.com/r/dquintela/softether-vpnserver-armel) |
| dquintela/softether-vpnbridge-armel | [![Image Size](https://images.microbadger.com/badges/image/dquintela/softether-vpnbridge-armel.svg)](https://microbadger.com/images/dquintela/softether-vpnbridge-armel) | [![Image Version](https://images.microbadger.com/badges/version/dquintela/softether-vpnbridge-armel.svg)](https://microbadger.com/images/dquintela/softether-vpnbridge-armel) | [![Docker Pulls](https://img.shields.io/docker/pulls/dquintela/softether-vpnbridge-armel.svg)](https://hub.docker.com/r/dquintela/softether-vpnbridge-armel) |
| dquintela/softether-vpnclient-armel | [![Image Size](https://images.microbadger.com/badges/image/dquintela/softether-vpnclient-armel.svg)](https://microbadger.com/images/dquintela/softether-vpnclient-armel) | [![Image Version](https://images.microbadger.com/badges/version/dquintela/softether-vpnclient-armel.svg)](https://microbadger.com/images/dquintela/softether-vpnclient-armel) | [![Docker Pulls](https://img.shields.io/docker/pulls/dquintela/softether-vpnclient-armel.svg)](https://hub.docker.com/r/dquintela/softether-vpnclient-armel) |
| dquintela/softether-rpi | [![Image Size](https://images.microbadger.com/badges/image/dquintela/softether-rpi.svg)](https://microbadger.com/images/dquintela/softether-rpi) | [![Image Version](https://images.microbadger.com/badges/version/dquintela/softether-rpi.svg)](https://microbadger.com/images/dquintela/softether-rpi) | [![Docker Pulls](https://img.shields.io/docker/pulls/dquintela/softether-rpi.svg)](https://hub.docker.com/r/dquintela/softether-rpi) |
| dquintela/softether-vpnserver-rpi | [![Image Size](https://images.microbadger.com/badges/image/dquintela/softether-vpnserver-rpi.svg)](https://microbadger.com/images/dquintela/softether-vpnserver-rpi) | [![Image Version](https://images.microbadger.com/badges/version/dquintela/softether-vpnserver-rpi.svg)](https://microbadger.com/images/dquintela/softether-vpnserver-rpi) | [![Docker Pulls](https://img.shields.io/docker/pulls/dquintela/softether-vpnserver-rpi.svg)](https://hub.docker.com/r/dquintela/softether-vpnserver-rpi) |
| dquintela/softether-vpnbridge-rpi | [![Image Size](https://images.microbadger.com/badges/image/dquintela/softether-vpnbridge-rpi.svg)](https://microbadger.com/images/dquintela/softether-vpnbridge-rpi) | [![Image Version](https://images.microbadger.com/badges/version/dquintela/softether-vpnbridge-rpi.svg)](https://microbadger.com/images/dquintela/softether-vpnbridge-rpi) | [![Docker Pulls](https://img.shields.io/docker/pulls/dquintela/softether-vpnbridge-rpi.svg)](https://hub.docker.com/r/dquintela/softether-vpnbridge-rpi) |
| dquintela/softether-vpnclient-rpi | [![Image Size](https://images.microbadger.com/badges/image/dquintela/softether-vpnclient-rpi.svg)](https://microbadger.com/images/dquintela/softether-vpnclient-rpi) | [![Image Version](https://images.microbadger.com/badges/version/dquintela/softether-vpnclient-rpi.svg)](https://microbadger.com/images/dquintela/softether-vpnclient-rpi) | [![Docker Pulls](https://img.shields.io/docker/pulls/dquintela/softether-vpnclient-rpi.svg)](https://hub.docker.com/r/dquintela/softether-vpnclient-rpi) |
| dquintela/softether-armhf | [![Image Size](https://images.microbadger.com/badges/image/dquintela/softether-armhf.svg)](https://microbadger.com/images/dquintela/softether-armhf) | [![Image Version](https://images.microbadger.com/badges/version/dquintela/softether-armhf.svg)](https://microbadger.com/images/dquintela/softether-armhf) | [![Docker Pulls](https://img.shields.io/docker/pulls/dquintela/softether-armhf.svg)](https://hub.docker.com/r/dquintela/softether-armhf) |
| dquintela/softether-vpnserver-armhf | [![Image Size](https://images.microbadger.com/badges/image/dquintela/softether-vpnserver-armhf.svg)](https://microbadger.com/images/dquintela/softether-vpnserver-armhf) | [![Image Version](https://images.microbadger.com/badges/version/dquintela/softether-vpnserver-armhf.svg)](https://microbadger.com/images/dquintela/softether-vpnserver-armhf) | [![Docker Pulls](https://img.shields.io/docker/pulls/dquintela/softether-vpnserver-armhf.svg)](https://hub.docker.com/r/dquintela/softether-vpnserver-armhf) |
| dquintela/softether-vpnbridge-armhf | [![Image Size](https://images.microbadger.com/badges/image/dquintela/softether-vpnbridge-armhf.svg)](https://microbadger.com/images/dquintela/softether-vpnbridge-armhf) | [![Image Version](https://images.microbadger.com/badges/version/dquintela/softether-vpnbridge-armhf.svg)](https://microbadger.com/images/dquintela/softether-vpnbridge-armhf) | [![Docker Pulls](https://img.shields.io/docker/pulls/dquintela/softether-vpnbridge-armhf.svg)](https://hub.docker.com/r/dquintela/softether-vpnbridge-armhf) |
| dquintela/softether-vpnclient-armhf | [![Image Size](https://images.microbadger.com/badges/image/dquintela/softether-vpnclient-armhf.svg)](https://microbadger.com/images/dquintela/softether-vpnclient-armhf) | [![Image Version](https://images.microbadger.com/badges/version/dquintela/softether-vpnclient-armhf.svg)](https://microbadger.com/images/dquintela/softether-vpnclient-armhf) | [![Docker Pulls](https://img.shields.io/docker/pulls/dquintela/softether-vpnclient-armhf.svg)](https://hub.docker.com/r/dquintela/softether-vpnclient-armhf) |
| dquintela/softether-aarch64 | [![Image Size](https://images.microbadger.com/badges/image/dquintela/softether-aarch64.svg)](https://microbadger.com/images/dquintela/softether-aarch64) | [![Image Version](https://images.microbadger.com/badges/version/dquintela/softether-aarch64.svg)](https://microbadger.com/images/dquintela/softether-aarch64) | [![Docker Pulls](https://img.shields.io/docker/pulls/dquintela/softether-aarch64.svg)](https://hub.docker.com/r/dquintela/softether-aarch64) |
| dquintela/softether-vpnserver-aarch64 | [![Image Size](https://images.microbadger.com/badges/image/dquintela/softether-vpnserver-aarch64.svg)](https://microbadger.com/images/dquintela/softether-vpnserver-aarch64) | [![Image Version](https://images.microbadger.com/badges/version/dquintela/softether-vpnserver-aarch64.svg)](https://microbadger.com/images/dquintela/softether-vpnserver-aarch64) | [![Docker Pulls](https://img.shields.io/docker/pulls/dquintela/softether-vpnserver-aarch64.svg)](https://hub.docker.com/r/dquintela/softether-vpnserver-aarch64) |
| dquintela/softether-vpnbridge-aarch64 | [![Image Size](https://images.microbadger.com/badges/image/dquintela/softether-vpnbridge-aarch64.svg)](https://microbadger.com/images/dquintela/softether-vpnbridge-aarch64) | [![Image Version](https://images.microbadger.com/badges/version/dquintela/softether-vpnbridge-aarch64.svg)](https://microbadger.com/images/dquintela/softether-vpnbridge-aarch64) | [![Docker Pulls](https://img.shields.io/docker/pulls/dquintela/softether-vpnbridge-aarch64.svg)](https://hub.docker.com/r/dquintela/softether-vpnbridge-aarch64) |
| dquintela/softether-vpnclient-aarch64 | [![Image Size](https://images.microbadger.com/badges/image/dquintela/softether-vpnclient-aarch64.svg)](https://microbadger.com/images/dquintela/softether-vpnclient-aarch64) | [![Image Version](https://images.microbadger.com/badges/version/dquintela/softether-vpnclient-aarch64.svg)](https://microbadger.com/images/dquintela/softether-vpnclient-aarch64) | [![Docker Pulls](https://img.shields.io/docker/pulls/dquintela/softether-vpnclient-aarch64.svg)](https://hub.docker.com/r/dquintela/softether-vpnclient-aarch64) |

## Run

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
