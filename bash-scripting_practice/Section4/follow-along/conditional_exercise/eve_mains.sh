#! /bin/bash

# Ask user for option
read -p "Do you want to see Evelaina's mains? [y/n]" option

echo -----------------------------------------------------

# Display response based on chosen option
if [ $option == "y" ]; then
   echo Morgana
   echo Lux
   echo Zyra
   echo Orianna
elif [ $option == "n" ]; then 
   echo Too bad.
else
   echo Nah man choose a valid option.
fi
