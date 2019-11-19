SERVER=view2301@ielab-s.dbio.usherbrooke.ca
PASS=`awk 'NR==2' /Users/wvieira/.Will_credentials` # get only line 2
ADRS=/../../../../srv/shiny-server
CODE=$(wildcard R/*.R)
data=$(wildcard data/*)
img=$(wildcard www/*)
SER=server.R
UI=ui.R

all: $(CODE) $(DATA) $(img) $(SER) $(UI)

	# connect to VPN
	cat /Users/wvieira/.Will_credentials | /opt/cisco/anyconnect/bin/vpn -s connect rpv.usherbrooke.ca

	# Use rsync to first create STM-managed directory (if doesn't exists) and then sync the changes files
	sshpass -p $(PASS) rsync -a --rsync-path="mkdir -p /home/local/USHERBROOKE/view2301/STM-managed/ && rsync" ~/GitHub/shiny_STM-managed/* $(SERVER):/home/local/USHERBROOKE/view2301/STM-managed/

	# Do all the server stuff with only one ssh using '&&'
	# '-t' flag is used because of sudo
	# '\' to new line to split each process
	## Process:
	  # rm old folder if exists
	  # copy from my user Server to the server root
	  # remove the copied folder
	  # change permissions of the figure and figure folder
	  # restart shiny Server
	sshpass -p $(PASS) ssh $(SERVER) -t "sudo cp -rf STM-managed/ ~$(ADRS)/ && \
	sudo chmod 775 $(ADRS)/STM-managed/www/ && \
	sudo chmod 664 $(ADRS)/STM-managed/www/model_pr.png && \
	sudo service  shiny-server restart"

	# Disconnect VPN
	/opt/cisco/anyconnect/bin/vpn disconnect
