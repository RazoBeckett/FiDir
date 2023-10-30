main-menu() {
    echo "Select an option:"
    echo "1. Filter with common category (e.g., music, video, text, shell)"
    echo "2. Filter with custom file type"
    echo "3. Exit"
    read -p "Enter your choice: " choice
}

customFileType () {
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

filters() {
    while true; do
    main-menu
        case $choice in
            1)  read -p "Enter filetype: " filetype
                customFileType "$filetype"
                ;;
            2)  
                ;;
            3)  exit 0
                ;;
            *)  echo "invalid choice, try again!!" 
                ;;
        esac
    done
}


filters