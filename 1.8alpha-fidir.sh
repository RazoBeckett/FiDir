#!/bin/bash

# Function to display files and directories by size using du command
display_files_by_size() {
  local above_1gb=""
  local under_1gb=""

  for file in *; do
    if [ -f "$file" ]; then
      file_size=$(du -h "$file" | cut -f1)

      if [ "$file_size" = "" ]; then
        file_size="0B"
      fi

      if [[ "$file_size" == *G ]]; then
        above_1gb="$above_1gb$file_size $file\n"
      else
        under_1gb="$under_1gb$file_size $file\n"
      fi
    elif [ -d "$file" ]; then
      dir_size=$(du -h -s "$file" | cut -f1)

      if [ "$dir_size" = "" ]; then
        dir_size="0B"
      fi

      if [[ "$dir_size" == *G ]]; then
        above_1gb="$above_1gb$dir_size $file\n"
      else
        under_1gb="$under_1gb$dir_size $file\n"
      fi
    fi
  done

  if [ -n "$above_1gb" ]; then
    echo "-------------------- Above 1GB -------------------"
    echo "Size           File/Dir Name"
    echo "----------------------------------------------------"
    printf "$above_1gb"
  fi

  if [ -n "$under_1gb" ]; then
    echo "-------------------- Under 1GB -------------------"
    echo "Size           File/Dir Name"
    echo "----------------------------------------------------"
    printf "$under_1gb"
  fi
}

# Function to display files by file type
display_files_by_type() {
  local categories_file="categories.json"

  for file in *; do
    if [ -f "$file" ]; then
      file_extension="${file##*.}"
      category="Other"

      if [ -f "$categories_file" ]; then
        while IFS= read -r line; do
          ext=$(echo "$line" | cut -d' ' -f1)
          cat=$(echo "$line" | cut -d' ' -f2)
          if [ "$ext" == "$file_extension" ]; then
            category="$cat"
            break
          fi
        done < "$categories_file"
      fi

      categories["$category"]="$categories[$category]$file\n"
    fi
  done

  for category in "${!categories[@]}"; do
    echo "========= $category ========="
    printf "${categories[$category]}"
  done
}

# Function to sort and display files/directories by date created
display_files_by_date_created() {
  echo "-------------------- Sort by Date Created -------------------"
  echo "File/Dir Name             Date Created"
  echo "-------------------------------------------------------------"
  for file in *; do
    if [ -f "$file" ] || [ -d "$file" ]; then
      file_date=$(stat -c "%y" "$file")
      echo "$file          $file_date"
    fi
  done | sort -k 2
}

# Function to list files/directories by last modified date
display_files_by_last_modified() {
  echo "-------------------- Sort by Last Modified Date -------------------"
  echo "File/Dir Name             Last Modified Date"
  echo "-------------------------------------------------------------"
  for file in *; do
    if [ -f "$file" ] || [ -d "$file" ]; then
      last_modified_date=$(stat -c "%y" "$file")
      echo "$file          $last_modified_date"
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
      display_files_by_size
      ;;
    2)
      display_files_by_type
      ;;
    3)
      display_files_by_date_created
      ;;
    4)
      display_files_by_last_modified
      ;;
    5)
      echo "Exiting program."
      exit 0
      ;;
    *)
      echo "Invalid choice. Please try again."
      ;;
  esac
done
