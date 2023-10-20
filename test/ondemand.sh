#!/bin/bash

# Function to list files of a specific type
list_files() {
    local file_type="$1"
    local header="========= $file_type Files ========="

    local files=($(find . -type f -name "*.$file_type"))
    if [ ${#files[@]} -gt 0 ]; then
        echo "$header"
        echo "Size           Date (Last Modified)          File/Dir Name"
        echo "------------------------------------------------------------"
        for file in "${files[@]}"; do
            file_date=$(stat -c "%y" "$file")
            file_size=$(du -sh "$file" | cut -f1)
            echo -e "$file_size\t\t${file_date%% *}\t\t$file"
        done
    else
        echo "No $file_type files found in the directory."
    fi
}

while true; do
    echo "Select an option:"
    echo "1. Filter with file type"
    echo "2. Exit"
    read -p "Enter your choice: " choice

    case $choice in
        1)
            read -p "Enter the file type: " file_type
            list_files "$file_type"
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
