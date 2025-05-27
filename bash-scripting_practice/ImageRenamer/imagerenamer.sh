#! /bin/bash

# Cleanup information file
cleanup() {
	if [[ -f file_info.txt  ]]; then
		rm file_info.txt
	fi
}

# Get the name of the image to be processed from user input
get_image_name() {
	read -p "Please provide us with the image name. " image_name
	echo "$image_name"
}

# Validate if a string is a valid floating number (positive or negative)
is_valid_number() {
    [[ $1 =~ ^-?[0-9]+(\.[0-9]+)?$ ]]
}

# Verify if file can be processed and is image
check_file_validity() {
	image_name=$1	

	# Check for file existence
	if [[ -z "$image_name" ]]; then
		echo "The provided filename is empty."
		return 1
	fi
	
	# Check that provided file is not a directory
	if [[ -d "$image_name" ]]; then
		echo "The provided filename is actually a directory. No further processing will take place."
		return 2
	fi

    if [[ ! -e "$image_name" ]]; then
        echo "The file does not exist."
        return 3
    fi

    local mimetype
    mimetype=$(file --mime-type -b "$image_name")
    if [[ $mimetype != image/* ]]; then
        echo "The provided file is not an image (detected MIME type: $mimetype)."
        return 4
    fi
}

# Sanitize filename by replacing spaces and slashes with underscores
sanitize_filename() {
    local input=$1
    input="${input// /_}"
    input="${input//\//_}"
    echo "$input"
}

# File rename data processing
process_data() {
    local image_name=$1
    echo "File $image_name will be renamed according to the location and creation time."

    # Get EXIF date tags in order
    local create_date
    create_date=$(exiftool -d "%Y-%m-%d" -DateTimeOriginal -s -s -s "$image_name")
    if [[ -z "$create_date" ]]; then
        create_date=$(exiftool -d "%Y-%m-%d" -CreateDate -s -s -s "$image_name")
    fi
    if [[ -z "$create_date" ]]; then
        create_date=$(exiftool -d "%Y-%m-%d" -ModifyDate -s -s -s "$image_name")
    fi

    # Get file modification date
    if [[ -z "$create_date" ]]; then
        if stat --version &>/dev/null; then
            # GNU stat (Linux)
            create_date=$(stat -c %y "$image_name" | cut -d ' ' -f1)
        else
            # BSD stat (macOS, maybe WSL)
            create_date=$(stat -f %Sm -t %Y-%m-%d "$image_name")
        fi
    fi

    if [[ -z "$create_date" ]]; then
        echo "Missing creation date info, cannot rename file reliably."
        return 1
    fi

    # Get GPS coordonates
    local latitude longitude
    latitude=$(exiftool -n -GPSLatitude -s -s -s "$image_name" 2>/dev/null)
    longitude=$(exiftool -n -GPSLongitude -s -s -s "$image_name" 2>/dev/null)

    # Check if GPS is valid
    if ! [[ "$latitude" =~ ^-?[0-9]+(\.[0-9]+)?$ ]] || ! [[ "$longitude" =~ ^-?[0-9]+(\.[0-9]+)?$ ]]; then
        echo "No valid GPS data found. Renaming file using only creation date."

        local ext="${image_name##*.}"
        local dir
        dir=$(dirname "$image_name")
        local newname="${create_date}.$ext"

        mv "$image_name" "$dir/$newname"
        echo "File renamed to: $dir/$newname"
        return 0
    fi

    # GPS present - get location name
    local response location
    response=$(curl -s "https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=$latitude&lon=$longitude" -A "YourScript/1.0")
    location=$(echo "$response" | jq -r '.address.city // .address.town // .address.village // "UnknownLocation"')
    location="${location// /_}"
    location="${location//\//_}"

    local ext="${image_name##*.}"
    local dir
    dir=$(dirname "$image_name")
    local newname="${create_date}_${location}.$ext"

    mv "$image_name" "$dir/$newname"
    echo "File renamed to: $dir/$newname"
    return 0
}

# Main program
cleanup

imgname=$(get_image_name)

if ! check_file_validity "$imgname"; then 
	echo "Aborting due to invalid input."
	exit 1
fi

process_data "$imgname"
