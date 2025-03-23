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

# Create hash.txt from the protected Word document
echo "Creating hash.txt from the protected Word document..."
python3 office2john.py Protected.docx > hash.txt

# Use John the Ripper to crack the password from the hash.txt file
echo "Starting password cracking process with John the Ripper..."
john --format=office-opencl hash.txt

# Display the cracked password
echo "Password cracking completed. Displaying cracked password..."
john --show hash.txt
