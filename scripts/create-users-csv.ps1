# Define the domain root (adjust as needed for your environment)
$domainRoot = "DC=home,DC=local"

# Prompt the user to enter the path to the CSV file
$csvFilePath = Read-Host "Enter the path to the CSV file (e.g. C:\Users\YourName\Documents\user-list.csv):"

# Function to create a user if they don't exist
function Create-User {
    param (
        [string]$firstName,   # User's first name
        [string]$lastName,    # User's last name
        [string]$ouName,      # Short OU name (e.g., IT, HR)
        [string]$groupName    # Group to which the user will be assigned
    )
    try {
        # Construct the full Distinguished Name (DN) for the OU
        $ouPath = "OU=$ouName,$domainRoot"

        # Construct the username in the format first.lastname
        $username = "$($firstName.ToLower()).$($lastName.ToLower())"
        $fullName = "$firstName $lastName"

        # Check if the user already exists
        if (-not (Get-ADUser -Filter "SamAccountName -eq '$username'" -ErrorAction SilentlyContinue)) {
            # Create the user
            New-ADUser -Name $fullName `
                       -GivenName $firstName `
                       -Surname $lastName `
                       -SamAccountName $username `
                       -UserPrincipalName "$username@home.local" `
                       -AccountPassword (ConvertTo-SecureString "P@ssword123" -AsPlainText -Force) `
                       -Path $ouPath `
                       -Enabled $true `
                       -ChangePasswordAtLogon $true `
                       -ErrorAction Stop

            # Output success message
            Write-Host "Successfully created user: $fullName in $ouPath with login: $username"

            # Add the user to their specific group
            Add-ADGroupMember -Identity $groupName -Members $username -ErrorAction Stop
            Write-Host "Added $fullName to group: $groupName"
        } else {
            # Inform the user if the account already exists
            Write-Host "User $fullName already exists with login: $username"
        }
    } catch {
        # Catch and display any errors
        Write-Host "Error creating user: $fullName. Error: $_"
    }
}

# Import user data from the CSV file
try {
    if (Test-Path $csvFilePath) {
        $userList = Import-Csv -Path $csvFilePath

        # Ensure the CSV contains the required headers
        if ($userList -and ($userList | Get-Member -Name "FirstName") -and ($userList | Get-Member -Name "LastName") -and ($userList | Get-Member -Name "OU") -and ($userList | Get-Member -Name "Group")) {
            # Loop through each user in the CSV file and create them
            foreach ($user in $userList) {
                Create-User -firstName $user.FirstName -lastName $user.LastName -ouName $user.OU -groupName $user.Group
            }
        } else {
            Write-Host "The CSV file is missing required headers. Ensure it includes 'FirstName', 'LastName', 'OU', and 'Group' at the top."
        }
    } else {
        Write-Host "CSV file not found at path: $csvFilePath .Try again."
    }
} catch {
    Write-Host "Error reading the CSV file. Error: $_"
}