#! /bin/bash

# Check user age
read -p "How old are you " age

if [ $age -lt 0 ]; then
	echo "____________________________________________________________"
	echo "You can't have a negative age, silly!"
	echo "We will exit this program for the safety of our application."
	echo "____________________________________________________________"
	exit
fi

if [ $age -lt 65 -a $age -gt 16 ]; then
	echo "____________________________________________________________"
	echo "You can legally work in Romania. Congrats!"
	echo "____________________________________________________________"
fi

# Give advice on graceful aging to user
read -sp "Type the password to know the secret to graceful aging. " psswd

if [[ $psswd == "retinol" || $psswd == "sunscreen" ]]; then
	echo ""
	echo "___________________________________________________________"
	echo "You already know it, beautiful! Retinol and suncreen."
	echo "___________________________________________________________"
# Check for empty password input
elif [ -z "$psswd" ]; then
	echo ""
	echo "___________________________________________________________"
	echo "Don't be shy, you should have told me."
	echo "___________________________________________________________"

else 
	echo ""
	echo "___________________________________________________________"
	echo "It will remain a secret..."
	echo "___________________________________________________________"
fi 

# Ask for personal data
read -p "In order to continue with our beauty analysis I will need your bank statement." bank_statement
money_laundering_scheme_file=$(eval echo "$bank_statement")
if [ -e "$money_laundering_scheme_file" ]; then
	echo ""
	echo "___________________________________________________________"
	echo "Thanks! Brb."
	
	for i in {1..50}
	do 
		echo "~"
		sleep 1
	done

	echo "Scammed! Bye!"
	echo "___________________________________________________________"
	exit
else
	echo "__________________________________________________________"
	echo "Wow, you're so protective about what? Your bank statement? pff."
fi
