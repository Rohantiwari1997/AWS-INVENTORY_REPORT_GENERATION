# AWS Inventory Tool - Quick Start Guide

## 🚀 5-Minute Setup

### Step 1: Install Dependencies (Amazon Linux 2)
```bash
# Run the automated installer
chmod +x install_packages.sh
./install_packages.sh
```

### Step 2: Configure AWS
```bash
aws configure
# Enter your AWS Access Key ID, Secret Key, and default region
```

### Step 3: Enable Resource Explorer
```bash
aws resource-explorer-2 create-index --type AGGREGATOR --region us-east-1
```

### Step 4: Run Inventory
```bash
# Basic run (all regions)
python3 aws_inventory.py --all-regions

# With S3 upload to terraform-aws1234 bucket
python3 aws_inventory.py --all-regions --s3-bucket terraform-aws1234

# Using automation script (pre-configured bucket)
./run_inventory.sh
```

## 📋 Common Commands

| Task | Command |
|------|---------|
| All regions | `python3 aws_inventory.py --all-regions` |
| Single region | `python3 aws_inventory.py --region us-east-1` |
| Multiple regions | `python3 aws_inventory.py --regions us-east-1 eu-west-1` |
| With S3 upload | `python3 aws_inventory.py --all-regions --s3-bucket terraform-aws1234` |
| Automated run | `./run_inventory.sh` |

## 📁 Output Files

- **Local**: `aws_inventory.json` and `aws_inventory.xlsx`
- **S3**: `s3://terraform-aws1234/AWS_Inventory/YYYYMMDD_HHMMSS/`

## ⚠️ Prerequisites

1. ✅ AWS Resource Explorer enabled
2. ✅ AWS credentials configured  
3. ✅ Python packages installed (`boto3`, `openpyxl`)
4. ✅ S3 bucket permissions (for upload)

## 🔧 Troubleshooting

| Issue | Solution |
|-------|----------|
| "Resource Explorer not enabled" | Run: `aws resource-explorer-2 create-index --type AGGREGATOR --region us-east-1` |
| "Access Denied" | Check AWS credentials and IAM permissions |
| "No resources found" | Wait 24-48 hours after enabling Resource Explorer |
| "S3 upload failed" | Verify bucket exists and check S3 permissions |

## 📞 Need Help?

Refer to the complete documentation: `AWS_INVENTORY_DOCUMENTATION.md`
