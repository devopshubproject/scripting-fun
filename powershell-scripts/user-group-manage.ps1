# PowerShell Script for Managing Users and Groups on Windows

function Show-Menu {
    Write-Host "1. Create a New User"
    Write-Host "2. Create a New Group"
    Write-Host "3. Add User to Group"
    Write-Host "4. Delete a User"
    Write-Host "5. Delete a Group"
    Write-Host "6. Exit"
}

do {
    Show-Menu
    $choice = Read-Host "Enter your choice"

    switch ($choice) {
        "1" {
            $username = Read-Host "Enter the new username"
            $password = Read-Host "Enter the password" -AsSecureString
            New-LocalUser -Name $username -Password $password -FullName $username -Description "Created by script"
            Write-Host "User $username created successfully."
        }
        "2" {
            $groupname = Read-Host "Enter the new group name"
            New-LocalGroup -Name $groupname
            Write-Host "Group $groupname created successfully."
        }
        "3" {
            $username = Read-Host "Enter the username to add"
            $groupname = Read-Host "Enter the group name"
            Add-LocalGroupMember -Group $groupname -Member $username
            Write-Host "User $username added to group $groupname."
        }
        "4" {
            $username = Read-Host "Enter the username to delete"
            Remove-LocalUser -Name $username
            Write-Host "User $username deleted."
        }
        "5" {
            $groupname = Read-Host "Enter the group name to delete"
            Remove-LocalGroup -Name $groupname
            Write-Host "Group $groupname deleted."
        }
        "6" {
            Write-Host "Exiting..."
            break
        }
        default {
            Write-Host "Invalid choice. Try again."
        }
    }
} while ($choice -ne "6")
