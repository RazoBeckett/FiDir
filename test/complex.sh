#!/bin/bash

# Define a mapping of common names to file extensions
declare -A file_type_mapping
file_type_mapping["music"]="mp3|flac|wav"
file_type_mapping["video"]="mp4|avi|mkv"
file_type_mapping["text"]="txt|pdf|docx"
file_type_mapping["shell"]="sh"

# Function to list files of a specific type
list_files() {
    local common_name="$1"
    local file_type="${file_type_mapping[$common_name]}"
    if [ -z "$file_type" ]; then
        echo "Common name '$common_name' is not recognized."
        return
    fi

    local header="========= $common_name Files ========="

    local files=($(find . -type f -iregex ".*\.\($file_type\)"))
    if [ ${#files[@]} -gt 0 ]; then
        echo "$header"
        echo "Size           Date (Last Modified)          File/Dir Name"
        echo "----------------------------------------------------"
        for file in "${files[@]}"; do
            file_date=$(stat -c "%y" "$file")
            file_size=$(du -sh "$file" | cut -f1)
            echo -e "$file_size\t${file_date%% *}  $file"
        done
    else
        echo "No $common_name files found in the directory."
    fi
}

while true; do
    echo "Select an option:"
    echo "1. Filter with common name (e.g., music, video, text, shell)"
    echo "2. Exit"
    read -p "Enter your choice: " choice

    case $choice in
        1)
            read -p "Enter the common name: " common_name
            list_files "$common_name"
            ;;
        2)
            echo "Goodbye!"
            exit 0
            ;;
        *)
            echo "Invalid choice. Please select a valid option."
            ;;
    esac
done
