# Active Directory User Mass Creation PowerShell Script

## Overview
This project contains multiple PowerShell scripts built to work seamlessly with the environment created through the **Home Lab Setup Guide** in my [home-lab-setup](https://github.com/urodz16/home-lab-setup/blob/main/documentation/lab-setup-guide.md) repository. These scripts automate the creation of users, Organizational Units (OUs), and groups in a clean Active Directory (AD) domain environment.

The primary purpose of this project is to practice and demonstrate fundamental Active Directory skills in a lab setting while building a foundation for more advanced automation and management projects.

---

## Current Capabilities

The repository now consists of the following scripts, each targeting a specific aspect of Active Directory management:

### 1. Organizational Unit Creation Script
- Script: create-OUs.ps1
- Capabilities:
	- Creates 3 OUs: IT, HR, and Finance.
	- Includes basic error handling to prevent duplication.

### 2. Group Creation Script
- Script: create-groups.ps1
- Capabilities:
	- Creates 6 groups:
      - IT-User, IT-Manager
      - HR-User, HR-Manager
      - Finance-User, Finance-Manager
    - Places groups within their respective OUs.

### 3. User Creation Scripts
- create-users-simple.ps1:
  - Capabilities:
    - Creates a small number of users with fixed parameters for testing.
    - Assigns users to their respective OUs and groups.

- create-users-csv.ps1:
  - Capabilities:
    - Imports user data from a CSV file.
    - Dynamically constructs full Distinguished Names (DNs) for OUs.
    - Assigns users to their respective groups based on CSV input.
    - Provides meaningful output messages and enhanced error handling.
  - Example CSV format:
  ```csv
      FirstName,LastName,OU,Group
      Tony,Stark,IT,IT-User
      Natasha,Romanoff,HR,HR-User

---

## Purpose

The main purpose of these scripts is to:
- Provide practical tools to populate an Active Directory environment with basic objects for testing and learning.
- Automate repetitive tasks to save time in a lab setting.
- Serve as stepping stones for more advanced PowerShell-based AD management projects.

---

## Future Enhancements
As this project evolves, I plan to:
1. Introduce advanced logging and reporting for better error tracking and auditability.
2. Expand the CSV-based user creation script to:
   - Lg successfully created users, failed attempts, and already existing accounts.
   - Include timestamps and the user running the script.
3. Transition this project into a broader **AD User Bulk Management** tool, capable of:
   - Modifications to existing users and groups.
   - Dynamic rule-based operations for group memberships and permissions.
   - Integration with Group Policy Objects (GPOs).

---

## Notes
- This script is designed for testing in lab environments and assumes a clean AD domain setup.
- It’s recommended to take VM snapshots before running the script to allow for repeated testing without rebuilding the domain.

---

## Getting Started
1. Clone this repository to your local machine.
2. Choose the appropiate script for your needs.
   - For Organizational Unit creation: [create-OUs.ps1](scripts/create-OUs.ps1)
   - For Group creation: [create-groups.ps1](scripts/create-groups.ps1)
   - For user creation within the script: [create-users-simple.ps1](scripts/create-users-simple.ps1)
   - For User creation through CSV file: [create-users-csv.ps1](scripts/create-users-csv.ps1)
3. Run the script in PowerShell with administrative privileges in a domain controller environment.
