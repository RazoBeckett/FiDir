# FiDir - File Sort with Filters

**FiDir** is a Bash script that simplifies the task of sorting and filtering files and directories in a directory hierarchy. With FiDir, you can quickly organize and display your files based on various criteria, such as size, file type, date created, last modified date, and file permissions.

## Features

- Sort and display files and directories based on various criteria.
- Filter files by file type or permission.
- Customize sorting options.
- User-friendly command-line interface.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Usage](#usage)
- [Menus](#menus)
- [Sort Functions](#sort-functions)
- [Filter Functions](#filter-functions)
- [Contributing](#contributing)
- [License](#license)

## Prerequisites

- A Linux system
- Bash shell

## Usage

To use FiDir, simply download the script and execute it in your desired directory. You can specify the directory as an argument (default is the current directory).
```bash
./fidir.sh [directory]
```
## Menus
FiDir includes three main menus:

- **Main Menu**: The main menu provides options to sort and display or filter and display files.

- **Sort Menu**: The sort menu allows you to choose sorting criteria and view files and directories accordingly.

- **Filter Menu**: The filter menu enables you to filter files based on file type or permission.

## Sort Functions
FiDir offers the following sort functions:

- Display files and directories by **size**.
- Display files by **file type**.
- Sort files/directories by **date created**.
- List files/directories by **last modified date**.

## Filter Functions
FiDir provides filter functions for:

- Filtering files by **custom file type** (user can manually specify which .fileExtension files they want to list).
- Filtering files by **permission** (readable, writable, or executable).

## Contributing
If you'd like to contribute to FiDir, please fork the repository and create a pull request with your changes.

## License
This project is licensed under the [MIT License](LICENSE).
