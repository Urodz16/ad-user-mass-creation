# Define users to create
# Each entry specifies user details, the OU, and the group to assign
$users = @(
    @{FirstName="Tony"; LastName="Stark"; OU="OU=IT,DC=home,DC=local"; Group="IT-Manager"},
    @{FirstName="Steve"; LastName="Rogers"; OU="OU=IT,DC=home,DC=local"; Group="IT-User"},
    @{FirstName="Natasha"; LastName="Romanoff"; OU="OU=HR,DC=home,DC=local"; Group="HR-User"},
    @{FirstName="Bruce"; LastName="Banner"; OU="OU=HR,DC=home,DC=local"; Group="HR-Manager"},
    @{FirstName="Clint"; LastName="Barton"; OU="OU=Finance,DC=home,DC=local"; Group="Finance-User"},
    @{FirstName="Wanda"; LastName="Maximoff"; OU="OU=Finance,DC=home,DC=local"; Group="Finance-Manager"}
)

# Default password for all users
$defaultPassword = ConvertTo-SecureString "Password12!@" -AsPlainText -Force

# Function to create a user if they don't exist
function Create-User {
    param (
        [string]$firstName,   # User's first name
        [string]$lastName,    # User's last name
        [string]$ouPath,      # Distinguished Name of the OU where the user will be created
        [string]$groupName    # Group to which the user will be assigned
    )
    try {
        # Construct the username and full name
        $username = "$($firstName.ToLower()).$($lastName.ToLower())"  # e.g., tony.stark
        $fullName = "$firstName $lastName"                                         # e.g., Tony Stark

        # Check if the user already exists
        if (-not (Get-ADUser -Filter "SamAccountName -eq '$username'" -ErrorAction SilentlyContinue)) {
            # Create the user
            New-ADUser -Name $fullName `
                       -GivenName $firstName `
                       -Surname $lastName `
                       -SamAccountName $username `
                       -UserPrincipalName "$username@home.local" `
                       -AccountPassword $defaultPassword `
                       -Path $ouPath `
                       -Enabled $true `
                       -ChangePasswordAtLogon $true `
                       -ErrorAction Stop

            Write-Host "Successfully created user: $fullName in $ouPath"

            # Add the user to their specific group
            Add-ADGroupMember -Identity $groupName -Members $username -ErrorAction Stop
            Write-Host "Added $fullName to group: $groupName"
        } else {
            # Inform the user if the account already exists
            Write-Host "User already exists: $username"
        }
    } catch {
        # Catch and display any errors
        Write-Host "Error creating user: $fullName. Error: $_"
    }
}

# Loop through the user list and create each one
foreach ($user in $users) {
    Create-User -firstName $user.FirstName -lastName $user.LastName -ouPath $user.OU -groupName $user.Group
}