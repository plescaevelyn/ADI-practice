#! /bin/bash

# Create .txt files
touch 1.txt 2.txt

# Write the content of pwd inside 1.txt in long list format
ls -l > 1.txt

# Ask user for 1.txt file prefix
read -p "Please provide a prefix for the 1.txt file " pref

# Change the name of 1.txt based on the prefix
mv 1.txt ${pref}1.txt
