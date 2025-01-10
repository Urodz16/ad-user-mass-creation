# We will be using this script to create 6 groups for our future users
# First we define the groups to create
# Each entry includes the group name and the OU where it should be created
$groups = @(
    @{Name="IT-User"; OU="OU=IT,DC=home,DC=local"},
    @{Name="IT-Manager"; OU="OU=IT,DC=home,DC=local"},
    @{Name="HR-User"; OU="OU=HR,DC=home,DC=local"},
    @{Name="HR-Manager"; OU="OU=HR,DC=home,DC=local"},
    @{Name="Finance-User"; OU="OU=Finance,DC=home,DC=local"},
    @{Name="Finance-Manager"; OU="OU=Finance,DC=home,DC=local"}
)

# Function to create a group if it doesn't exist
function Create-Group {
    param (
        [string]$groupName,  # The name of the group to create
        [string]$ouPath      # The Distinguished Name of the OU where the group should be created
    )
    try {
        # Check if the group already exists
        if (-not (Get-ADGroup -Filter "Name -eq '$groupName'" -ErrorAction SilentlyContinue)) {
            # Create the group
            New-ADGroup -Name $groupName `
                        -GroupScope Global `
                        -GroupCategory Security `
                        -Path $ouPath `
                        -Description "$groupName group for assigning permissions" `
                        -ErrorAction Stop
            Write-Host "Successfully created group: $groupName in $ouPath"
        } else {
            # Inform the user if the group already exists
            Write-Host "Group already exists: $groupName"
        }
    } catch {
        # Catch and display errors encountered during group creation
        Write-Host "Error creating group: $groupName in $ouPath. Error: $_"
    }
}

# Loop through the list of groups and create each one
foreach ($group in $groups) {
    Create-Group -groupName $group.Name -ouPath $group.OU
}