#!/bin/bash

# AWS Inventory Script with S3 Upload to terraform-aws1234 bucket
# Usage: ./run_inventory.sh

BUCKET="terraform-aws1234"
OUTPUT_NAME="aws_inventory"

echo "=== AWS Resource Inventory Script ==="
echo "Timestamp: $(date)"
echo "S3 Bucket: $BUCKET"
echo ""

echo "Generating AWS inventory across all regions..."
python3 aws_inventory.py --all-regions --output $OUTPUT_NAME --s3-bucket $BUCKET

if [ $? -eq 0 ]; then
    echo ""
    echo "✓ Inventory generation completed successfully"
    echo "✓ Files uploaded to S3: s3://$BUCKET/AWS_Inventory/$(date +%Y%m%d_%H%M%S)/"
    
    # Clean up local files
    echo "Cleaning up local files..."
    rm -f ${OUTPUT_NAME}.*
    
    echo "✓ Process completed successfully"
else
    echo "✗ Inventory generation failed"
    exit 1
fi
