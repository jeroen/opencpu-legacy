OpenCPU consists of 3 Ubuntu packages:

 * opencpu-server (main OpenCPU server) 
 * opencpu-cache (cache server + load balancer)
 * opencpu-cran (cron job to install all cran packages)
 
For now, we only support the latest Ubuntu 11.10 (Oneiric).

To get this to work, install a freshy copy of Ubuntu Server 11.10 and run the following commands:

	sudo apt-get install apt-utils python-software-properties
	sudo add-apt-repository ppa:opencpu/beta2
	
	sudo apt-get update
	sudo apt-get upgrade
	
	sudo apt-get install opencpu-server

It should install out of the box. After installing, you can start and restart the R server and sandbox independently:

	sudo service opencpu-server {start, stop, restart}
	sudo service opencpu-sandbox {start, stop, restart}
	
To install the cache server / load balancer, do:

	sudo apt-get instal opencpu-cache
	
You can stop and start the cache server using 

	sudo service opencpu-cache {start, stop, restart}

