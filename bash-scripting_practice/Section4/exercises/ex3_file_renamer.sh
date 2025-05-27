#!/bin/bash

# Cleanup
cleanup() {
	if [ -d ./created_files ]; then
		rm -R created_files
	fi
}

# Create files
create_text_files() {
	file_number=$1
	filename=$2
	file_type=$3

	mkdir created_files
	echo ""

	for i in $(seq 1 "$file_number"); do
		if [[ $file_type == "i" || $file_type == "I" ]]; then 
			touch "./created_files/${filename}${i}.jpg"
		elif [[ $file_type == "t" || $file_type == "T" ]]; then
			touch "./created_files/${filename}${i}.txt"
		else 
			echo "Invalid option chosen. Program will exit."
			exit
		fi

		echo -n "*"
		sleep 0.1
	done

	sleep 1
	echo ""
	echo "File creation done."
}

# Rename file(s)
rename_files() {
	check=$1        # yes or no
	file_type=$2    # text or image

	if [[ $check == "n" || $check == "N" ]]; then
		echo "Not proceeding with the renaming operation. Exiting program."
		exit
	elif [[ $check == "y" || $check == "Y" ]]; then
		read -p "Would you like renaming the files by adding a prefix or a suffix? [ p / s ]  " rename_type

		if [[ $rename_type == "p" || $rename_type == "P" || $rename_type == "prefix" ]]; then
			read -p "Please provide the new prefix: " new_name_seq

			if [[ $file_type == "t" || $file_type == "T" ]]; then
				cd ./created_files
				for file_n in *.txt; do
					mv "$file_n" "${new_name_seq}${file_n}"
				done
			elif [[ $file_type == "i" || $file_type == "I" ]]; then
				cd ./created_files
				for file_n in *.jpg; do
					mv "$file_n" "${new_name_seq}${file_n}"
				done
			else 
				echo "Invalid file type chosen."
			fi

		elif [[ $rename_type == "s" || $rename_type == "S" || $rename_type == "suffix" ]]; then
			read -p "Please provide the new suffix: " new_name_seq

			if [[ $file_type == "t" || $file_type == "T" ]]; then
				cd ./created_files
				for file_n in *.txt; do
					base_name="${file_n%.txt}"
					mv "$file_n" "${base_name}${new_name_seq}.txt"
				done
			elif [[ $file_type == "i" || $file_type == "I" ]]; then
				cd ./created_files
				for file_n in *.jpg; do
					base_name="${file_n%.jpg}"
					mv "$file_n" "${base_name}${new_name_seq}.jpg"
				done
			else 
				echo "Invalid file type chosen."
			fi
		else
			echo "Invalid rename type."
		fi
	fi
}

# Main program portion
cleanup

read -p "How many files do you want to create?  " file_number
read -p "How do you want to name your files?  " filename
read -p "Would you like creating .txt or .jpg files? [ t / i ]  " option

create_text_files $file_number $filename $option

read -p "Would you like renaming the files by adding a prefix or suffix? [y / n]  " check
if [[ $check == "y" || $check == "Y" ]]; then
	read -p "Would you like renaming the text or image files? [t / i]  " file_type
	rename_files $check $file_type
else
	echo "Alright."
fi
