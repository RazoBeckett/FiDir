#!/bin/bash

# Function to display a menu and get user's choice
display_menu() {
    echo "Select an option:"
    echo "1. List Music Files"
    echo "2. List Video Files"
    echo "3. List Text Files"
    echo "4. List Shell Files"
    echo "5. Exit"
    read -p "Enter your choice: " choice
}

# Function to list files of a specific type
list_files() {
    case $1 in
        1)
            echo "Music Files:"
            find . -type f -name "*.mp3" -o -name "*.flac" -o -name "*.wav"
            ;;
        2)
            echo "Video Files:"
            find . -type f -name "*.mp4" -o -name "*.avi" -o -name "*.mkv"
            ;;
        3)
            echo "Text Files:"
            find . -type f -name "*.txt" -o -name "*.pdf" -o -name "*.docx"
            ;;
        4)
            echo "Shell Files:"
            find . -type f -name "*.sh"
            ;;
    esac
}

while true; do
    display_menu
    case $choice in
        1|2|3|4)
            list_files $choice
            ;;
        5)
            echo "Goodbye!"
            exit 0
            ;;
        *)
            echo "Invalid choice. Please select a valid option."
            ;;
    esac
done
