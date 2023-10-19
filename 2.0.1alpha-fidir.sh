#!/bin/bash
path="${1:-.}"
cd "$path" || exit 1

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

  echo "-------------------- Sort by Size -------------------"
  echo "Size           Date (Last Modified)          File/Dir Name"
  echo "----------------------------------------------------"

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
  local images=""
  local videos=""
  local text_files=""
  local shell_files=""
  local other_files=""

  for file in *; do
    if [ -f "$file" ]; then
      file_type="${file##*.}"
      case "$file_type" in
        txt)
          text_files="$text_files$file "
          ;;
        sh)
          shell_files="$shell_files$file "
          ;;
        jpg|jpeg|png|gif|bmp)
          images="$images$file "
          ;;
        mp4|avi|mkv|mov)
          videos="$videos$file "
          ;;
        *)
          other_files="$other_files$file "
          ;;
      esac
    fi
  done

  if [ -n "$images" ]; then
    echo "========= Image Files ========="
    echo "Size           Date (Last Modified)          File/Dir Name"
    echo "----------------------------------------------------"
    for file in $images; do
      file_date=$(stat -c "%y" "$file")
      file_size=$(du -sh "$file" | cut -f1)
      echo -e "$file_size\t${file_date%% *}  $file"
    done
  fi

  if [ -n "$videos" ]; then
    echo "========= Video Files ========="
    echo "Size           Date (Last Modified)          File/Dir Name"
    echo "----------------------------------------------------"
    for file in $videos; do
      file_date=$(stat -c "%y" "$file")
      file_size=$(du -sh "$file" | cut -f1)
      echo -e "$file_size\t${file_date%% *}  $file"
    done
  fi

  if [ -n "$text_files" ]; then
    echo "========= Text Files (.txt) ========="
    echo "Size           Date (Last Modified)          File/Dir Name"
    echo "----------------------------------------------------"
    for file in $text_files; do
      file_date=$(stat -c "%y" "$file")
      file_size=$(du -sh "$file" | cut -f1)
      echo -e "$file_size\t${file_date%% *}  $file"
    done
  fi

  if [ -n "$shell_files" ]; then
    echo "========= Shell Scripts (.sh) ========="
    echo "Size           Date (Last Modified)          File/Dir Name"
    echo "----------------------------------------------------"
    for file in $shell_files; do
      file_date=$(stat -c "%y" "$file")
      file_size=$(du -sh "$file" | cut -f1)
      echo -e "$file_size\t${file_date%% *}  $file"
    done
  fi

  if [ -n "$other_files" ]; then
    echo "========= Other Files ========="
    echo "Size           Date (Last Modified)          File/Dir Name"
    echo "----------------------------------------------------"
    for file in $other_files; do
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
  echo "----------------------------------------------------"
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
  echo "-------------------- Sort by Last Modified Date -------------------"
  echo "Size           Date (Last Modified)          File/Dir Name"
  echo "----------------------------------------------------"
  for file in *; do
    if [ -f "$file" ] || [ -d "$file" ]; then
      last_modified_date=$(stat -c "%y" "$file")
      file_size=$(du -sh "$file" | cut -f1)
      printf "%-16s %-20s %s\n" "$file_size" "${last_modified_date%% *}" "$file"
    fi
  done | sort -k 2
}



# Display menu
echo "File Viewer with Filters"
echo "1. Display files and directories by size"
echo "2. Display files by file type"
echo "3. Sort files/directories by date created"
echo "4. List files/directories by last modified date"
echo "5. Exit"

while true; do
  read -p "Enter your choice: " choice

  case $choice in
    1)
      clear
      display_files_by_size
      ;;
    2)
      clear
      display_files_by_type
      ;;
    3)
      clear
      display_files_by_date_created
      ;;
    4)
      clear
      display_files_by_last_modified
      ;;
    5|q)
      clear
      echo "Exiting program."
      exit 0
      ;;
    *)
      clear
      echo "Invalid choice. Please try again."
      ;;
  esac
done