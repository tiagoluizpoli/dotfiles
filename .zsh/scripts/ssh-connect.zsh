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
  # local config=$(jq -r ".${connection_name}" "$CONFIG_FILE")
  local config=$(jq -r ".\"${connection_name}\"" "$CONFIG_FILE")


  if [[ $config == "null" ]]; then
    echo "Error: Connection '$connection_name' not found in configuration file."
    return 1
  fi

  # Extract individual fields from the configuration
  local pem_path=$(echo "$config" | jq -r '.pem_path')
  local local_port=$(echo "$config" | jq -r '.local_port')
  local remote_host=$(echo "$config" | jq -r '.remote_host')
  local remote_port=$(echo "$config" | jq -r '.remote_port')
  local user=$(echo "$config" | jq -r '.user')
  local instance_ip=$(echo "$config" | jq -r '.instance_ip')

  if [[ -z $pem_path || -z $local_port || -z $remote_host || -z $remote_port || -z $user || -z $instance_ip ]]; then
    echo "Error: Missing required fields in configuration for '$connection_name'."
    return 1
  fi

  # Construct and execute the SSH command
  # local ssh_command="ssh -i $pem_path -L $local_port:$remote_host:$remote_port $user@$instance_ip"
  # local ssh_command=\"ssh -i \\\"$pem_path\\\" -L $local_port:$remote_host:$remote_port $user@$instance_ip\"
  local ssh_command=("ssh" "-i" "$pem_path" "-L" "$local_port:$remote_host:$remote_port" "$user@$instance_ip")



  echo "Connecting to '$connection_name' with command: $ssh_command"
  # eval $ssh_command
  "${ssh_command[@]}"

}

# Alias to simplify usage
alias ssh-connect="connect_ssh"
