# Define the OUs to create
# Each entry specifies the Distinguished Name (DN) of an OU to create
$OUs = @(
    "OU=IT,DC=home,DC=local",
    "OU=HR,DC=home,DC=local",
    "OU=Finance,DC=home,DC=local"
)

# Function to create an OU if it doesn't exist
function Create-OU {
    param (
        [string]$ouDN  # The full DN of the OU to create
    )
    try {
        # Check if the OU already exists using Get-ADOrganizationalUnit
        if (-not (Get-ADOrganizationalUnit -Filter "DistinguishedName -eq '$ouDN'" -ErrorAction SilentlyContinue)) {
            # Parse the OU name and path from the DN
            $ouName = ($ouDN -split ",")[0] -replace "OU=", ""  # Extracts the name of the OU
            $ouPath = ($ouDN -replace "OU=.*?,", "")            # Extracts the parent path (e.g., domain root)

            # Create the OU with the extracted name and path
            New-ADOrganizationalUnit -Name $ouName -Path $ouPath -ProtectedFromAccidentalDeletion $true -ErrorAction Stop
            Write-Host "Successfully created OU: $ouDN"
        } else {
            # Inform the user if the OU already exists
            Write-Host "OU already exists: $ouDN"
        }
    } catch {
        # Catch and display errors encountered during the OU creation
        Write-Host "Error creating OU: $ouDN. Error: $_"
    }
}

# Loop through the list of OUs and create each one
foreach ($ou in $OUs) {
    Create-OU -ouDN $ou
}