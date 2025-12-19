# AWS Resource Inventory Script

Comprehensive AWS resource inventory tool using AWS Resource Explorer to extract resources across all regions and generate Excel reports.

## Prerequisites

### Amazon Linux 2 Setup

1. **Install Python 3 and pip**:
```bash
sudo yum update -y
sudo yum install python3 python3-pip -y
```

2. **Install Required Python Packages**:
```bash
pip3 install boto3 openpyxl
```

3. **Configure AWS Credentials**:
```bash
aws configure
# OR set environment variables:
export AWS_ACCESS_KEY_ID=your_access_key
export AWS_SECRET_ACCESS_KEY=your_secret_key
export AWS_DEFAULT_REGION=us-east-1
```

### Required AWS Permissions

Attach the following managed policies to your IAM user/role:
- `ReadOnlyAccess` (recommended)
- OR create custom policy with these permissions:
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "resource-explorer-2:Search",
                "resource-explorer-2:ListIndexes",
                "ec2:DescribeRegions",
                "s3:PutObject",
                "s3:PutObjectAcl"
            ],
            "Resource": "*"
        }
    ]
}
```

### Enable AWS Resource Explorer

Resource Explorer must be enabled in your AWS account:
```bash
aws resource-explorer-2 create-index --type AGGREGATOR --region us-east-1
```

## Usage

### Basic Commands

**All Regions (Recommended)**:
```bash
python3 aws_inventory.py --all-regions --output complete_inventory
```

**Single Region**:
```bash
python3 aws_inventory.py --region ap-south-1 --output single_region
```

**Multiple Specific Regions**:
```bash
python3 aws_inventory.py --regions us-east-1 us-west-2 eu-west-1 --output multi_region
```

### Output Files

Each run generates:
- `{output_name}.json` - Complete JSON data
- `{output_name}.xlsx` - Excel spreadsheet

## S3 Upload Integration

### S3 Folder Structure

Files are automatically uploaded to S3 with this structure:
```
s3://your-bucket/AWS_Inventory/YYYYMMDD_HHMMSS/
├── aws_inventory.json
└── aws_inventory.xlsx
```

Example:
```
s3://my-inventory-bucket/AWS_Inventory/20251219_143052/
├── aws_inventory.json
└── aws_inventory.xlsx
```

### Usage with S3 Upload

**Direct Command**:
```bash
python3 aws_inventory.py --all-regions --s3-bucket my-inventory-bucket
```

**Using Automation Script**:
```bash
./run_inventory.sh my-inventory-bucket
```

### S3 Bucket Permissions

Ensure your IAM user/role has these S3 permissions:
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:PutObjectAcl"
            ],
            "Resource": "arn:aws:s3:::your-bucket-name/AWS_Inventory/*"
        }
    ]
}
```

### Example S3 Paths

Each execution creates a new timestamped folder:
- `s3://bucket/AWS_Inventory/20251219_090000/` (9:00 AM run)
- `s3://bucket/AWS_Inventory/20251219_140000/` (2:00 PM run)
- `s3://bucket/AWS_Inventory/20251219_210000/` (9:00 PM run)

## Scheduling with Cron

Add to crontab for daily execution:
```bash
crontab -e
# Add this line for daily 2 AM execution:
0 2 * * * /path/to/run_inventory.sh >> /var/log/aws_inventory.log 2>&1
```

## Output Format

Excel contains these columns:
- **Service**: AWS service name (ec2, lambda, s3, etc.)
- **ResourceType**: Specific resource type (ec2:instance, s3:bucket, etc.)
- **Identifier**: Resource ID/name
- **ARN**: Amazon Resource Name
- **Application**: Application tag value (if available)
- **AWSAccount**: AWS Account ID
- **Region**: AWS region
- **LastReportedAt**: Last update timestamp

## Troubleshooting

### Common Issues

1. **Resource Explorer not enabled**:
```bash
aws resource-explorer-2 create-index --type AGGREGATOR --region us-east-1
```

2. **Permission denied**:
   - Ensure IAM user has required permissions
   - Check AWS credentials configuration

3. **No resources found**:
   - Wait 24-48 hours after enabling Resource Explorer
   - Verify resources exist in the account

4. **S3 upload fails**:
   - Check bucket exists and permissions
   - Verify S3 write permissions in IAM policy

### Package Installation Issues

If pip3 install fails on Amazon Linux 2:
```bash
# Alternative installation
sudo yum install python3-devel gcc -y
pip3 install --user boto3 openpyxl
```

## Example Output

```
Processing ap-south-1...
✓ Found 157 resources in ap-south-1
Processing us-east-1...
✓ Found 52 resources in us-east-1
...
Total resources found: 311

JSON saved to final_aws_inventory.json
Excel saved to final_aws_inventory.xlsx
```

## Support

For issues or questions:
1. Check AWS Resource Explorer is enabled
2. Verify IAM permissions
3. Ensure all required packages are installed
4. Check AWS credentials configuration
