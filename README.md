This package installs the opencpu-node (R server) on Ubuntu. 
For now, we only support the latest Ubuntu 11.10 (Oneiric).

To get this to work, install a freshy copy of Ubuntu Server 11.10 and run the following commands:

	sudo apt-get install apt-utils python-software-properties
	sudo add-apt-repository ppa:opencpu/beta1
	
	sudo apt-get update
	sudo apt-get upgrade
	
	sudo apt-get install opencpu-node

It should install out of the box. After installing, you can start and restart the R server and sandbox independently:

	sudo service opencpu-server {start, stop, restart}
	sudo service opencpu-sandbox {start, stop, restart}