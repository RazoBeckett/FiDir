#!/bin/bash

# Function to list music files
list_music_files() {
    echo "========= Music Files ========="
    echo "Size           Date (Last Modified)          File/Dir Name"
    echo "----------------------------------------------------"
    find . -type f -name "*.mp3" -o -name "*.flac" -o -name "*.wav" | while read -r file; do
        file_date=$(stat -c "%y" "$file")
        file_size=$(du -sh "$file" | cut -f1)
        echo -e "$file_size\t${file_date%% *}  $file"
    done
}

# Function to list video files
list_video_files() {
    echo "========= Video Files ========="
    echo "Size           Date (Last Modified)          File/Dir Name"
    echo "----------------------------------------------------"
    find . -type f -name "*.mp4" -o -name "*.avi" -o -name "*.mkv" | while read -r file; do
        file_date=$(stat -c "%y" "$file")
        file_size=$(du -sh "$file" | cut -f1)
        echo -e "$file_size\t${file_date%% *}  $file"
    done
}

# Function to list text files
list_text_files() {
    echo "========= Text Files ========="
    echo "Size           Date (Last Modified)          File/Dir Name"
    echo "----------------------------------------------------"
    find . -type f -name "*.txt" -o -name "*.pdf" -o -name "*.docx" | while read -r file; do
        file_date=$(stat -c "%y" "$file")
        file_size=$(du -sh "$file" | cut -f1)
        echo -e "$file_size\t${file_date%% *}  $file"
    done
}

# Function to list shell files
list_shell_files() {
    echo "========= Shell Scripts ========="
    echo "Size           Date (Last Modified)          File/Dir Name"
    echo "----------------------------------------------------"
    find . -type f -name "*.sh" | while read -r file; do
        file_date=$(stat -c "%y" "$file")
        file_size=$(du -sh "$file" | cut -f1)
        echo -e "$file_size\t${file_date%% *}  $file"
    done
}

# Call the functions
list_music_files
list_video_files
list_text_files
list_shell_files
