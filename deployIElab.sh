
# copy from my compute to the server
scp -r ~/GitHub/shiny_managementSTM/ view2301@ielab-s.dbio.usherbrooke.ca:/home/local/USHERBROOKE/view2301/STM-managed

# enter in the Server
shinyIElab # password needed

# copy from my user Server to the server root and remove the copied folder
sudo cp -r STM-managed/ ~/../../../../srv/shiny-server/
rm -rf STM-managed

# go to the root directory
cd ../../../../srv/shiny-server/STM-managed/

# change permissions of the figure and figure folder
sudo chmod 775 www/
sudo chmod 664 www/model_pr.png

# restart shiny Server
sudo service  shiny-server restart
