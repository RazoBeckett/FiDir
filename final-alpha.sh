#!/bin/bash
path="${1:-.}"
cd "$path" || exit 1

# MENUS SECTION

## SORT MENU
sort-menu(){
    clear
    while true; do
        echo "=================================================="
        echo "1. Display files and directories by size"
        echo "2. Display files by file type"
        echo "3. Sort files/directories by date created"
        echo "4. List files/directories by last modified date"
        echo "5. Back"
        echo "=================================================="
        read -p "Enter your choice: " schoice
        clear
        case $schoice in
            1)  display_files_by_size
                ;;
            2)  display_files_by_type
                ;;
            3)  display_files_by_date_created
                ;;
            4)  display_files_by_last_modified
                ;;
            5)  start
                ;;
            *)  echo "Invalid choice. Please try again."
                ;;
        esac
    done
}

## FILTER MENU
filter-menu(){
    clear
    while true; do
        echo "=================================================="
        echo "1. Filter with file type"
        echo "2. Back"
        echo "3. exit"
        echo "=================================================="
        read -p "Enter your choice: " fchoice
        clear
        case $fchoice in
            1)  read -p "Enter the file type: " file_type
                list_files "$file_type"
                ;;
            2)  start
                ;;
            3)  exit 0
                ;;
            *)
                echo "Invalid choice. Please select a valid option."
                ;;
        esac
    done
}

## MAIN MENU
main-menu(){
    clear
    echo "=== FiDir - File Sort with Filters ==="
    echo "1. Sort and display"
    echo "2. Filter and display"
    echo "3. exit"
    echo "======================================="
    read -p "Enter your choice: " choice
    clear
}


########################## SORT FUNCTIONS SECTION - START ##########################

# Function to display files and directories by size using du command
display_files_by_size() {
  echo "Sort by Size:"
  echo "1. Sort from big to small size"
  echo "2. Sort from small to big size"
  echo "Enter your choice: "
  read -r sort_choice

  if [ "$sort_choice" = "1" ]; then
    sort_option="-k 1,1hr"
  elif [ "$sort_choice" = "2" ]; then
    sort_option="-k 1h"
  else
    echo "Invalid choice. Defaulting to big to small size sort."
    sort_option="-k 1,1hr"
  fi

  echo "------------------------ Sort by Size -----------------------"
  echo "Size           Date (Last Modified)          File/Dir Name"
  echo "-------------------------------------------------------------"

  for file in *; do
    if [ -f "$file" ]; then
      file_size=$(du -h "$file" | cut -f1)
      last_modified_date=$(stat -c "%y" "$file")
      printf "%-16s %-20s %s\n" "$file_size" "${last_modified_date%% *}" "$file"
    elif [ -d "$file" ]; then
      dir_size=$(du -h -s "$file" | cut -f1)
      last_modified_date=$(stat -c "%y" "$file")
      printf "%-16s %-20s %s\n" "$dir_size" "${last_modified_date%% *}" "$file"
    fi
  done | sort $sort_option
}

# Function to display files by file type
display_files_by_type() {
  local file_types=("jpg|jpeg|png|gif|bmp" "mp4|avi|mkv|mov" "txt" "sh")
  
  for type in "${file_types[@]}"; do
    files=($(find . -maxdepth 1 -type f -name "*.$type"))
    if [ ${#files[@]} -gt 0 ]; then
      echo "========================= ${type^^} Files ========================"
      echo "Size           Date (Last Modified)          File/Dir Name"
      echo "-------------------------------------------------------------"
      for file in "${files[@]}"; do
        file_date=$(stat -c "%y" "$file")
        file_size=$(du -sh "$file" | cut -f1)
        echo -e "$file_size\t${file_date%% *}  $file"
      done
    fi
  done

  # Handle other file types
  other_files=($(find . -maxdepth 1 -type f -not -name "*.*"))
  if [ ${#other_files[@]} -gt 0 ]; then
    echo "======================== Other Files ========================"
    echo "Size           Date (Last Modified)          File/Dir Name"
    echo "-------------------------------------------------------------"
    for file in "${other_files[@]}"; do
      file_date=$(stat -c "%y" "$file")
      file_size=$(du -sh "$file" | cut -f1)
      echo -e "$file_size\t${file_date%% *}  $file"
    done
  fi
}


# Function to sort and display files/directories by date created
display_files_by_date_created() {
  echo "-------------------- Sort by Date Created -------------------"
  echo "Size           Date (Created)          File/Dir Name"
  echo "-------------------------------------------------------------"
  for file in *; do
    if [ -f "$file" ] || [ -d "$file" ]; then
      file_date=$(stat -c "%y" "$file")
      file_size=$(du -sh "$file" | cut -f1)
      printf "%-16s %-20s %s\n" "$file_size" "${file_date%% *}" "$file"
    fi
  done | sort -k 2
}

# Function to list files/directories by last modified date
display_files_by_last_modified() {
  echo "----------------- Sort by Last Modified Date ----------------"
  echo "Size           Date (Last Modified)          File/Dir Name"
  echo "-------------------------------------------------------------"
  for file in *; do
    if [ -f "$file" ] || [ -d "$file" ]; then
      last_modified_date=$(stat -c "%y" "$file")
      file_size=$(du -sh "$file" | cut -f1)
      printf "%-16s %-20s %s\n" "$file_size" "${last_modified_date%% *}" "$file"
    fi
  done | sort -k 2
}
########################### SORT FUNCTIONS SECTION - END ###########################


######################### FILTER FUCNTIONS SECTION - START #########################

# Function to list files of a specific type
list_files() {
    local file_type="$1"
    local files=($(find . -type f -name "*.$file_type"))
    if [ ${#files[@]} -gt 0 ]; then
        echo "======================= $file_type Files ======================="
        echo "Size           Date (Last Modified)          File/Dir Name"
        echo "-------------------------------------------------------------"
        for file in "${files[@]}"; do
            file_date=$(stat -c "%y" "$file")
            file_size=$(du -sh "$file" | cut -f1)
            echo -e "$file_size\t\t${file_date%% *}\t\t$file"
        done
    else
        echo "No $file_type files found in the directory."
    fi
}

########################## FILTER FUCNTIONS SECTION - EHD ##########################

start(){
    while true; do
        main-menu
        case $choice in
            1)  sort-menu
                ;;
            2)  filter-menu
                ;;
            3)  exit 0
                ;;
            *)  echo "Invalid choice, try agin... "
                sleep 2
                clear
                ;;
        esac
    done
}

start