#! /bin/bash

# Read the user's personal information
read -p "Hello, sir or madam. Be so kind as to provide me your name." name
read -sp "Thank you so much. Please provide me your password." psswd

# Provide feedback
echo "---------------------------------"
echo "Hello, $name. Your account has been successfully hacked."
echo "Goodbye, bash world."
echo "---------------------------------"
