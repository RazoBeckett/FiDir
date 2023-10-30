#!/bin/bash

# Function to display files by file type
display_files_by_type() {
  local categories_file="categories.json"

  for file in *; do
    if [ -f "$file" ]; then
      file_extension="${file##*.}"

      # Read the configuration file and retrieve the full form
      full_form=$(jq -r ".$file_extension" "$categories_file")

      # Determine the category based on the full form
      if [ -n "$full_form" ]; then
        category="$full_form"
      else
        category="Other"
      fi

      # Group the files by category
      categories["$category"]="$categories[$category]$file\n"
    fi
  done

  # Display the categories
  for category in "${!categories[@]}"; do
    echo "========= $category ========="
    printf "${categories[$category]}"
  done
}

# Display menu
echo "File Viewer with Filters"
echo "1. Display files by category"
echo "2. Exit"

while true; do
  read -p "Enter your choice: " choice

  case $choice in
    1)
      display_files_by_type
      ;;
    2)
      echo "Exiting program."
      exit 0
      ;;
    *)
      echo "Invalid choice. Please try again."
      ;;
  esac
done
