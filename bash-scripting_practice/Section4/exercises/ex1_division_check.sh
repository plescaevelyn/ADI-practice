#! /bin/bash

# Check if a number is divisible by 2, 3 or 5 in a function.
division_check() { 
    num=$1
    echo "Gorgeous, gorgeous girls provide number $num. TYSM angel. Let's thoroughly analyse this number and lemme tell
    ya something about it!"

    if (( $num < 0 )); then
	echo "I'm so sorry angel, nobody wants to divide with this idiotic unnatural number. Not even euglena verde."
    	exit
    fi 
    if (( $num % 2 == 0 )); then
	  echo "Slay girl! DIVISIBLE BY 2"
    fi 
    if (( $num % 3 == 0 )); then
	  echo "Ate. Them. Up. DIVISIBLE BY 3"
    fi 
    if (( $num % 5 == 0 )); then
	  echo "You are worthy. You are gorgeous. You are DIVISIBLE BY 5" 
    fi
}


read -p "Give me a number bestie" number

# Check whether the inputted number is valid or not
if [[ "$number" =~ ^[0-9]+([.][0-9]+)?$ ]]; then
    echo "Guuuurl let me COOK"
    echo "___________________"
    division_check $number
else 
    echo "You a fraud"
    exit 1
fi

