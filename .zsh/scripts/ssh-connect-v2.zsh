#!/bin/zsh

# Define the path to the JSON configuration file
CONFIG_FILE="$HOME/.zsh/ssh-connection-config.json"

# Function to load configuration and connect via SSH
function connect_ssh() {
  local connection_name=$1

  # Check if jq is installed
  if ! command -v jq >/dev/null; then
    echo "Error: jq is not installed. Please install jq to use this script."
    return 1
  fi

  # Check if the configuration file exists
  if [[ ! -f $CONFIG_FILE ]]; then
    echo "Error: Configuration file not found at $CONFIG_FILE"
    return 1
  fi

  # Extract the connection configuration using jq
  local config=$(jq -r ".\"${connection_name}\"" "$CONFIG_FILE")


  if [[ $config == "null" ]]; then
    echo "Error: Connection '$connection_name' not found in configuration file."
    return 1
  fi

  # Extract individual fields from the configuration
  local pem_path=$(echo "$config" | jq -r '.pem_path')
  local password=$(echo "$config" | jq -r '.password')
  local local_port=$(echo "$config" | jq -r '.local_port')
  local remote_host=$(echo "$config" | jq -r '.remote_host')
  local remote_port=$(echo "$config" | jq -r '.remote_port')
  local user=$(echo "$config" | jq -r '.user')
  local instance_ip=$(echo "$config" | jq -r '.instance_ip')

  # Check for essential fields common to all connections
  if [[ -z $local_port || -z $remote_host || -z $remote_port || -z $user || -z $instance_ip ]]; then
    echo "Error: Missing required fields (local_port, remote_host, remote_port, user, instance_ip) in configuration for '$connection_name'."
    return 1
  fi

  # --- BUILD THE SSH COMMAND ---
  local ssh_command=("") # Start with an empty command array
  local is_password_auth=false

  # 1. Check for password and use sshpass if found
  if [[ -n $password && $password != "null" && $pem_path == "null" ]]; then
      # Check if sshpass is installed
      if ! command -v sshpass >/dev/null; then
          echo "Error: 'sshpass' is required for password-based non-interactive login. Please install it."
          return 1
      fi
      
      echo "Warning: Using 'sshpass' with a plaintext password from config for '$connection_name'. Consider using an SSH key."
      ssh_command=("sshpass" "-p" "$password" "ssh")
      is_password_auth=true
  else
      # 2. Otherwise, start with standard ssh
      ssh_command=("ssh")
  fi

  # 3. Add identity file (PEM) if specified and we aren't using password auth
  # If both are set, the script favors the PEM file.
  if [[ -n $pem_path && $pem_path != "null" ]]; then
    ssh_command+=("-i" "$pem_path")
  fi

  # 4. Add port forwarding
  ssh_command+=("-L" "$local_port:$remote_host:$remote_port")

  # 5. Add user and instance IP
  ssh_command+=("$user@$instance_ip")
  # --- END SSH COMMAND BUILD ---

  echo "Connecting to '$connection_name' with command: ${ssh_command[*]}"
  
  # Execute the constructed command
  "${ssh_command[@]}"

}

# Alias to simplify usage
alias ssh-connect="connect_ssh"