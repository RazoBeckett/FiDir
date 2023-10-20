#!/bin/bash

# Function to list files with a specific permission
list_files_by_permission() {
    local permission="$1"
    local header="========= Files with '$permission' Permission ========="

    local files=()
    if [ "$permission" == "read" ] || [ "$permission" == "r" ]; then
        files=($(find . -type f -perm /u=r,g=r,o=r))
    elif [ "$permission" == "write" ] || [ "$permission" == "w" ]; then
        files=($(find . -type f -perm /u=w,g=w,o=w))
    elif [ "$permission" == "execute" ] || [ "$permission" == "x" ]; then
        files=($(find . -type f -perm /u=x,g=x,o=x))
    else
        echo "Invalid permission. Please use 'read', 'write', 'execute', 'r', 'w', or 'x'."
        return
    fi

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
        echo "No files with '$permission' permission found in the directory."
    fi
}

while true; do
    echo "Select an option:"
    echo "1. List files with a specific permission"
    echo "2. Exit"
    read -p "Enter your choice: " choice

    case $choice in
        1)
            read -p "Enter the permission (e.g., 'read', 'write', 'execute', 'r', 'w', or 'x'): " permission
            list_files_by_permission "$permission"
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
