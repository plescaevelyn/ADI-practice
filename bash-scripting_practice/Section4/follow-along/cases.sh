#! /bin/bash

echo "Type a character to know who should be your main in League of Legends please!"
read car

case $car in 
	[0-9]) 
		echo "You typed a number! ^_^"
		;;
	"a" | "A")
	       echo "Akali"
	       ;;
        "b" | "B")
 		echo "Bard"
		;;
	"c" | "C")
		echo "Caitlyn"
		;;
	"d" | "D")
		echo "Dr. Mundo"
		;;
	"e" | "E")
		echo "Evelynn"
		;;
	"m" | "M")
		echo "Morgana"
		;;
	"l" | "L")
		echo "Lux"
		;;
	"z" | "Z")
		echo "Zyra"
		;;
	*)
		echo "Research it yourself please."
		;;
esac	
	
