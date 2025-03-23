#!/bin/bash

# Step 1: Install John the Ripper
echo "Installing John the Ripper..."
sudo apt update
sudo apt install john

# Download the office2john.py script from the official John the Ripper repository
echo "Downloading office2john.py script..."
wget https://raw.githubusercontent.com/openwall/john/bleeding-jumbo/run/office2john.py -O office2john.py

# Make sure the file has the right permissions to be executed
chmod +x office2john.py

# Ask for the full path of the protected Word document
while true; do
    read -p "Enter the full path of the protected Word document: " doc_path

    # Check if the file exists and is a valid file
    if [ -f "$doc_path" ]; then
        echo "File found: $doc_path"
        break  # Exit the loop if the file exists
    else
        echo "The file '$doc_path' does not exist or is not a valid file. Please try again."
    fi
done

# Create hash.txt from the protected Word document
echo "Creating hash.txt from the protected Word document..."
python3 office2john.py "$doc_path" > hash.txt

# Check if hash.txt was successfully created
if [ ! -f hash.txt ]; then
    echo "Failed to create hash.txt. Exiting..."
    exit 1
fi

# Remove prefix's from the hash file
sed -i 's/^[^:]*://g' hash.txt

# Use John the Ripper to crack the password from the hash.txt file
echo "Starting password cracking process with John the Ripper..."
john --format=office-opencl hash.txt

# Step 6: Display the cracked password
echo "Password cracking completed. Displaying cracked password..."
john --show hash.txt
