#!/bin/bash

# AWS Inventory Script - Package Installation for Amazon Linux 2

echo "=== Installing Required Packages for AWS Inventory Script ==="

# Update system
echo "Updating system packages..."
sudo yum update -y

# Install Python 3 and pip
echo "Installing Python 3 and pip..."
sudo yum install python3 python3-pip -y

# Install required Python packages
echo "Installing Python packages..."
pip3 install --user boto3 openpyxl

# Verify installations
echo ""
echo "=== Verification ==="
echo "Python version: $(python3 --version)"
echo "Pip version: $(pip3 --version)"

echo ""
echo "Checking installed packages..."
python3 -c "import boto3; print('✓ boto3 installed:', boto3.__version__)"
python3 -c "import openpyxl; print('✓ openpyxl installed:', openpyxl.__version__)"

echo ""
echo "=== Setup Complete ==="
echo "You can now run the AWS inventory script:"
echo "  python3 aws_inventory.py --all-regions --output my_inventory"
echo ""
echo "Don't forget to configure AWS credentials:"
echo "  aws configure"
