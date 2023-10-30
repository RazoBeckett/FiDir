#!/bin/bash

# Function to convert file size to human-readable format
human_readable_size() {
  local bytes="$1"
  local units=("B" "KB" "MB" "GB" "TB" "PB" "EB" "ZB" "YB")
  local i=0
  while ((bytes > 1024)); do
    bytes=$(awk "BEGIN {printf \"%.2f\", $bytes / 1024}")
    ((i++))
  done
  echo "$bytes ${units[i]}"
}

# Function to display files and directories by size
display_files_by_size() {
  local above_1gb=""
  local under_1gb=""
  
  for file in *; do
    if [ -f "$file" ]; then
      file_size=$(du -b "$file" | awk '{print $1}')
      file_size_human=$(human_readable_size "$file_size")
      if [ "$file_size" -gt 1000000000 ]; then
        above_1gb="$above_1gb$file_size_human $file\n"
      else
        under_1gb="$under_1gb$file_size_human $file\n"
      fi
    elif [ -d "$file" ]; then
      dir_size=$(du -sb "$file" | awk '{print $1}')
      dir_size_human=$(human_readable_size "$dir_size")
      if [ "$dir_size" -gt 1000000000 ]; then
        above_1gb="$above_1gb$dir_size_human $file\n"
      else
        under_1gb="$under_1gb$dir_size_human $file\n"
      fi
    fi
  done
  
  if [ -n "$above_1gb" ]; then
    echo "-------- Above 1GB -----------"
    printf "$above_1gb"
  fi

  if [ -n "$under_1gb" ]; then
    echo "-------- Under 1GB -----------"
    printf "$under_1gb"
  fi
}

# Function to display files by file type
display_files_by_type() {
  local text_files=""
  local shell_files=""
  local other_files=""
  
  for file in *; do
    if [ -f "$file" ]; then
      file_type="${file##*.}"
      case "$file_type" in
        txt)
          text_files="$text_files$file\n"
          ;;
        sh)
          shell_files="$shell_files$file\n"
          ;;
        *)
          other_files="$other_files$file\n"
          ;;
      esac
    fi
  done
  
  if [ -n "$text_files" ]; then
    echo "--------- Text Files (.txt) -----------"
    printf "$text_files"
  fi

  if [ -n "$shell_files" ]; then
    echo "--------- Shell Scripts (.sh) -----------"
    printf "$shell_files"
  fi

  if [ -n "$other_files" ]; then
    echo "--------- Other Files ------------"
    printf "$other_files"
  fi
}

# Display menu
echo "File Viewer with Filters"
echo "1. Display files and directories by size"
echo "2. Display files by file type"
echo "3. Exit"

while true; do
  read -p "Enter your choice: " choice
  
  case $choice in
    1)
      display_files_by_size
      ;;
    2)
      display_files_by_type
      ;;
    3)
      echo "Exiting program."
      exit 0
      ;;
    *)
      echo "Invalid choice. Please try again."
      ;;
  esac
done
