#!/bin/bash

# Function to display menu
show_menu() {
    echo "1. Create a New User"
    echo "2. Create a New Group"
    echo "3. Add User to Group"
    echo "4. Delete a User"
    echo "5. Delete a Group"
    echo "6. Exit"
}

while true; do
    show_menu
    read -p "Enter your choice: " choice

    case $choice in
        1)
            read -p "Enter the new username: " username
            sudo adduser $username
            echo "User $username created successfully."
            ;;
        2)
            read -p "Enter the new group name: " groupname
            sudo groupadd $groupname
            echo "Group $groupname created successfully."
            ;;
        3)
            read -p "Enter the username to add: " username
            read -p "Enter the group name: " groupname
            sudo usermod -aG $groupname $username
            echo "User $username added to group $groupname."
            ;;
        4)
            read -p "Enter the username to delete: " username
            sudo deluser $username
            echo "User $username deleted."
            ;;
        5)
            read -p "Enter the group name to delete: " groupname
            sudo groupdel $groupname
            echo "Group $groupname deleted."
            ;;
        6)
            echo "Exiting..."
            break
            ;;
        *)
            echo "Invalid choice. Try again."
            ;;
    esac
done
