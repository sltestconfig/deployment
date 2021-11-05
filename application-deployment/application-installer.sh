#!/bin/bash


###### INSTALL APACHE2 ######

sudo apt update
sudo apt install apache2 -y 
sudo systemctl enable apache2
sudo systemctl restart apache2
