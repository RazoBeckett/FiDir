#!/bin/bash
path="${1:-.}"
cd "$path" || exit 1

# Arrays to store files of different types
declare -a images
declare -a videos
declare -a text_files
declare -a shell_files
declare -a other_files

# Function to categorize files by type and store them in arrays
categorize_files() {
  for file in *; do
    if [ -f "$file" ]; then
      file_type="${file##*.}"
      case "$file_type" in
        txt)
          text_files+=("$file")
          ;;
        sh)
          shell_files+=("$file")
          ;;
        jpg|jpeg|png|gif|bmp)
          images+=("$file")
          ;;
        mp4|avi|mkv|mov)
          videos+=("$file")
          ;;
        *)
          other_files+=("$file")
          ;;
      esac
    fi
  done
}

# Function to display files in an array
display_files() {
  local arr_name=("$@")
  local category=$1

  if [ "${#arr_name[@]}" -gt 0 ]; then
    echo "========= $category ========="
    echo "Size           Date (Last Modified)          File/Dir Name"
    echo "----------------------------------------------------"
    for file in "${arr_name[@]}"; do
      if [ -f "$file" ]; then
        file_date=$(stat -c "%y" "$file")
        file_size=$(du -sh "$file" | cut -f1)
        echo -e "$file_size\t${file_date%% *}  $file"
      fi
    done
  fi
}

# Display menu
echo "=== FiDir - File Sort with Filters ==="
echo "1. Categorize files by type"
echo "2. Display categorized files"
echo "3. Exit"

while true; do
  read -p "Enter your choice: " choice

  case $choice in
    1)
      clear
      categorize_files
      ;;
    2)
      clear
      display_files "Image Files" "${images[@]}"
      display_files "Video Files" "${videos[@]}"
      display_files "Text Files (.txt)" "${text_files[@]}"
      display_files "Shell Scripts (.sh)" "${shell_files[@]}"
      display_files "Other Files" "${other_files[@]}"
      ;;
    3|q)
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

