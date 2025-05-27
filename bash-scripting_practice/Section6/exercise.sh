#!/bin/bash

# Cleanup
cleanup() {
	if [ -d ./detected-files ]; then
		rm -R ./detected-files
	fi
}

# Setup destination folder
setup_folder() {
	mkdir ./detected-files
}

# Search a file for the keyword and copy if match found
get_file() {
	local keyword="$1"
	local filepath="$2"

	check=$(grep -ni "$keyword" "$filepath")

	if [ ! -z "$check" ]; then
		filename=$(basename "$filepath")
		cp "$filepath" ./detected-files/"$filename"
		{
			echo ""
			echo "──────── MATCHES ────────"
			echo "$check"
			echo "────────────────────────"
		} >> ./detected-files/"$filename"
		return 0
	else
		return 1
	fi
}

# Recursively scan directories and show match counts
scan_all() {
	local base_path="$1"
	local keyword="$2"

	shopt -s nullglob

	for dir in $(find "$base_path" -type d); do
		if [[ "$dir" != "./detected-files" ]]; then
			echo ""
			echo "SCANNING FOLDER → $dir"

			local folder_matches=0

			for file in "$dir"/*.txt; do
				if [ -f "$file" ]; then
					if get_file "$keyword" "$file"; then
						folder_matches=$((folder_matches + 1))
					fi
				fi
			done

			echo "Occurences found: $folder_matches"
		fi
	done
}

# Main program portion
echo ""
read -p "Enter the path to the folder you want to scan: " scan_path
read -p "What keyword are you looking for? " keyword
echo ""

if [ ! -d "$scan_path" ]; then
	echo "Inexistent folder. Please try again."
	exit 1
fi

cleanup
setup_folder
scan_all "$scan_path" "$keyword"

echo ""
echo "All keyword occurences are saved in ./detected-files"
