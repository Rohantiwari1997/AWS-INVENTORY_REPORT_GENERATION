# AWS Resource Inventory Tool - Complete Documentation

## 📋 Overview

The AWS Resource Inventory Tool is a comprehensive Python script that extracts resource information from all AWS services across all regions using AWS Resource Explorer. It generates both JSON and Excel reports and automatically uploads them to S3 with organized folder structure.

## 🎯 Key Features

- **Comprehensive Coverage**: Extracts resources from all AWS services across all regions
- **Multiple Output Formats**: JSON (raw data) and Excel (formatted reports)
- **Automated S3 Upload**: Organized storage with timestamp-based folders
- **Parallel Processing**: Fast execution using concurrent region processing
- **Error Handling**: Graceful handling of service limitations and permissions
- **Production Ready**: Suitable for enterprise environments and automation

## 📦 Package Contents

```
aws-inventory-tool/
├── aws_inventory.py          # Main script
├── README.md                 # Basic usage guide
├── requirements.txt          # Python dependencies
├── run_inventory.sh          # Automated execution script
├── install_packages.sh       # Amazon Linux 2 setup script
└── AWS_INVENTORY_DOCUMENTATION.md  # This document
```

## 🔧 System Requirements

### Amazon Linux 2 Setup

1. **Update System**:
```bash
sudo yum update -y
```

2. **Install Python 3 and pip**:
```bash
sudo yum install python3 python3-pip -y
```

3. **Install Required Python Packages**:
```bash
pip3 install boto3 openpyxl
```

### Alternative Installation (if pip fails)

```bash
sudo yum install python3-devel gcc -y
pip3 install --user boto3 openpyxl
```

### Quick Setup Script

Use the provided installation script:
```bash
chmod +x install_packages.sh
./install_packages.sh
```

## 🔐 AWS Configuration

### 1. AWS Credentials

Configure AWS credentials using one of these methods:

**Method 1: AWS CLI**
```bash
aws configure
```

**Method 2: Environment Variables**
```bash
export AWS_ACCESS_KEY_ID=your_access_key
export AWS_SECRET_ACCESS_KEY=your_secret_key
export AWS_DEFAULT_REGION=us-east-1
```

**Method 3: IAM Role** (Recommended for EC2 instances)
- Attach IAM role to EC2 instance with required permissions

### 2. Required AWS Permissions

**Recommended**: Attach `ReadOnlyAccess` managed policy

**Custom Policy** (minimal permissions):
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "resource-explorer-2:Search",
                "resource-explorer-2:ListIndexes",
                "ec2:DescribeRegions"
            ],
            "Resource": "*"
        },
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

### 3. Enable AWS Resource Explorer

**CRITICAL**: Resource Explorer must be enabled before using the script:

```bash
aws resource-explorer-2 create-index --type AGGREGATOR --region us-east-1
```

**Note**: Allow 24-48 hours for Resource Explorer to index existing resources.

## 🚀 Usage Guide

### Basic Commands

**1. All Regions Inventory (Recommended)**:
```bash
python3 aws_inventory.py --all-regions --output complete_inventory
```

**2. Single Region**:
```bash
python3 aws_inventory.py --region ap-south-1 --output single_region
```

**3. Multiple Specific Regions**:
```bash
python3 aws_inventory.py --regions us-east-1 us-west-2 eu-west-1 --output multi_region
```

**4. With S3 Upload**:
```bash
python3 aws_inventory.py --all-regions --s3-bucket my-inventory-bucket
```

### Command Line Options

| Option | Description | Example |
|--------|-------------|---------|
| `--all-regions` | Scan all AWS regions | `--all-regions` |
| `--region` | Single region scan | `--region us-east-1` |
| `--regions` | Multiple regions | `--regions us-east-1 eu-west-1` |
| `--output` | Output filename (no extension) | `--output my_inventory` |
| `--s3-bucket` | S3 bucket for upload | `--s3-bucket my-bucket` |

## 📁 Output Structure

### Local Files

Each execution generates:
- `{output_name}.json` - Complete raw data in JSON format
- `{output_name}.xlsx` - Formatted Excel spreadsheet

### S3 Storage Structure

When using S3 upload, files are organized as:
```
s3://your-bucket/AWS_Inventory/YYYYMMDD_HHMMSS/
├── aws_inventory.json
└── aws_inventory.xlsx
```

**Examples**:
- `s3://my-bucket/AWS_Inventory/20251219_090000/` (9:00 AM execution)
- `s3://my-bucket/AWS_Inventory/20251219_140000/` (2:00 PM execution)
- `s3://my-bucket/AWS_Inventory/20251219_210000/` (9:00 PM execution)

### Excel Report Format

The Excel file contains these columns:

| Column | Description | Example |
|--------|-------------|---------|
| Service | AWS service name | `ec2`, `lambda`, `s3` |
| ResourceType | Specific resource type | `ec2:instance`, `s3:bucket` |
| Identifier | Resource ID/name | `i-1234567890abcdef0` |
| ARN | Amazon Resource Name | `arn:aws:ec2:us-east-1:123456789012:instance/i-1234567890abcdef0` |
| Application | Application tag value | `WebApp`, `Database` |
| AWSAccount | AWS Account ID | `123456789012` |
| Region | AWS region | `us-east-1`, `ap-south-1` |
| LastReportedAt | Last update timestamp | `2025-12-19T10:30:00+00:00` |

## 🔄 Automation & Scheduling

### 1. Automated Script

Use the provided automation script:
```bash
chmod +x run_inventory.sh
./run_inventory.sh my-inventory-bucket
```

### 2. Cron Job Setup

**Daily execution at 2 AM**:
```bash
crontab -e
# Add this line:
0 2 * * * /path/to/run_inventory.sh my-inventory-bucket >> /var/log/aws_inventory.log 2>&1
```

**Weekly execution (Sundays at 3 AM)**:
```bash
0 3 * * 0 /path/to/run_inventory.sh my-inventory-bucket >> /var/log/aws_inventory.log 2>&1
```

### 3. Custom Automation Script

Create your own automation script:
```bash
#!/bin/bash
BUCKET="my-inventory-bucket"
LOG_FILE="/var/log/inventory.log"

echo "$(date): Starting AWS inventory..." >> $LOG_FILE
python3 /path/to/aws_inventory.py --all-regions --s3-bucket $BUCKET >> $LOG_FILE 2>&1

if [ $? -eq 0 ]; then
    echo "$(date): Inventory completed successfully" >> $LOG_FILE
else
    echo "$(date): Inventory failed" >> $LOG_FILE
    # Send alert email/notification
fi
```

## 🔍 Troubleshooting

### Common Issues & Solutions

**1. Resource Explorer Not Enabled**
```
Error: Resource Explorer not enabled in region
```
**Solution**:
```bash
aws resource-explorer-2 create-index --type AGGREGATOR --region us-east-1
```

**2. Permission Denied**
```
Error: Access Denied
```
**Solution**:
- Verify AWS credentials: `aws sts get-caller-identity`
- Check IAM permissions
- Ensure S3 bucket permissions for upload

**3. No Resources Found**
```
Found 0 resources in region
```
**Solution**:
- Wait 24-48 hours after enabling Resource Explorer
- Verify resources exist in the account/region
- Check if Resource Explorer has completed indexing

**4. S3 Upload Fails**
```
S3 upload failed: Access Denied
```
**Solution**:
- Verify S3 bucket exists
- Check S3 permissions in IAM policy
- Ensure bucket policy allows PutObject

**5. Package Installation Issues**
```
ModuleNotFoundError: No module named 'boto3'
```
**Solution**:
```bash
pip3 install --user boto3 openpyxl
# OR
sudo yum install python3-devel gcc -y
pip3 install boto3 openpyxl
```

### Verification Commands

**Check AWS Configuration**:
```bash
aws sts get-caller-identity
aws configure list
```

**Check Python Packages**:
```bash
python3 -c "import boto3; print('boto3:', boto3.__version__)"
python3 -c "import openpyxl; print('openpyxl:', openpyxl.__version__)"
```

**Test Resource Explorer**:
```bash
aws resource-explorer-2 list-indexes --region us-east-1
```

## 📊 Sample Output

### Console Output
```
Processing ap-south-1...
✓ Found 157 resources in ap-south-1
Processing us-east-1...
✓ Found 52 resources in us-east-1
Processing eu-west-1...
✓ Found 17 resources in eu-west-1

JSON saved to aws_inventory.json
Excel saved to aws_inventory.xlsx
✓ Uploaded aws_inventory.xlsx to s3://my-bucket/AWS_Inventory/20251219_143052/aws_inventory.xlsx
✓ Uploaded aws_inventory.json to s3://my-bucket/AWS_Inventory/20251219_143052/aws_inventory.json

Total resources found: 311
```

### Resource Distribution Example
```
Region          Resources
ap-south-1      157
us-east-1       52
eu-west-1       17
ap-southeast-1  17
eu-central-1    12
Total           255
```

## 🏢 Enterprise Deployment

### Production Considerations

1. **IAM Role**: Use IAM roles instead of access keys
2. **Logging**: Implement comprehensive logging
3. **Monitoring**: Set up CloudWatch alarms for failures
4. **Backup**: Store reports in multiple S3 buckets/regions
5. **Security**: Use S3 bucket encryption and access logging

### Multi-Account Setup

For organizations with multiple AWS accounts:

1. **Cross-Account Role**: Create IAM role in each account
2. **Assume Role**: Modify script to assume roles
3. **Centralized Storage**: Store all reports in central S3 bucket
4. **Account Tagging**: Add account information to reports

### Integration with Other Tools

- **AWS Config**: Compare with Config inventory
- **AWS Systems Manager**: Use for patch compliance correlation
- **Cost Explorer**: Correlate with cost data
- **Security Hub**: Integration for security findings

## 📞 Support & Maintenance

### Regular Maintenance Tasks

1. **Monthly**: Review and update IAM permissions
2. **Quarterly**: Validate Resource Explorer coverage
3. **Annually**: Review and optimize script performance

### Monitoring Checklist

- [ ] Resource Explorer indexes are healthy
- [ ] S3 uploads are successful
- [ ] Cron jobs are running
- [ ] Log files are not growing too large
- [ ] IAM permissions are still valid

### Performance Optimization

- **Parallel Processing**: Already implemented (5 concurrent regions)
- **Region Filtering**: Skip regions with no resources
- **Incremental Updates**: Consider delta reporting for large environments
- **Compression**: Compress JSON files for large inventories

## 📝 Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2025-12-19 | Initial release with Resource Explorer integration |
| 1.1 | 2025-12-19 | Added S3 upload with organized folder structure |
| 1.2 | 2025-12-19 | Enhanced documentation and automation scripts |

---

**Contact**: For issues or enhancements, refer to the troubleshooting section or create detailed issue reports with error logs and environment information.
