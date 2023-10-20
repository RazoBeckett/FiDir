#!/bin/bash

# Function to list files of a specific type
list_files() {
    local file_type="$1"
    local header=""

    case "$file_type" in
        "mp3|flac|wav")
            header="========= Music Files ========="
            ;;
        "mp4|avi|mkv")
            header="========= Video Files ========="
            ;;
        "txt|pdf|docx")
            header="========= Text Files ========="
            ;;
        "sh")
            header="========= Shell Scripts ========="
            ;;
        *)
            return
            ;;
    esac

    local files=($(find . -type f -name "*.$file_type"))
    if [ ${#files[@]} -gt 0 ]; then
        echo "$header"
        echo "Size           Date (Last Modified)          File/Dir Name"
        echo "----------------------------------------------------"
        for file in "${files[@]}"; do
            file_date=$(stat -c "%y" "$file")
            file_size=$(du -sh "$file" | cut -f1)
            echo -e "$file_size\t${file_date%% *}  $file"
        done
    fi
}

# Call the functions for specific file types
list_files "mp3|flac|wav"
list_files "mp4|avi|mkv"
list_files "txt|pdf|docx"
list_files "sh"
