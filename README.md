

## Run

WORK IN PROGRESS - DON'T USE

Simplest version:

    docker run -d --net host --cap-add NET_ADMIN --name vpnserver dquintela/i386-softether vpnserver
	
This is start vpnserver with random passwords (see console? how?) and a default configuration that as connectivity with 
docker host only (link to docker network here)

	docker run -d --net host --cap-add NET_ADMIN --name vpnbridge dquintela/i386-softether vpnbridge
	docker start --net host --cap-add NET_ADMIN --name vpnbridge dquintela/i386-softether vpnbridge
	
This will start vpnbridge that connects to ?

TODO: Example without --net host

Passing configuration:

	touch /home/dquintela/vpnserver/vpn_server.config # If file is not previously existent
	docker run -d -v /home/dquintela/vpnserver/vpn_server.config:/usr/local/softether/vpnserver/vpn_server.config --net host --cap-add NET_ADMIN --name vpnserver dquintela/i386-softether vpnserver
	
Passing directory for logs:

	Using volume directory

	mkdir /home/dquintela/vpnserver/logs
	docker run -d -v /home/dquintela/vpnserver/logs:/var/log/softether --net host --cap-add NET_ADMIN --name vpnserver dquintela/i386-softether vpnserver

	Using docker volume
	
	docker volume create --name softether-logs
	docker run -d --net host --cap-add NET_ADMIN -v softether-logs:/var/log/vpnserver --name vpnserver dquintela/i386-softether vpnserver