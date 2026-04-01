#!/bin/bash
# GNOME Extension Automatic Installer
# Based on the user's provided list and image.

# --- 1. CONFIGURATION ---
EXTENSIONS=(
    "cronomix@zagortenay333"
    "dash-to-panel@jderose9.github.com"
    "gTile@vibou"
    "copyous@boerdereinar.dev"
    "tilingshell@ferrarodomenico.com"
)

EXT_DIR="$HOME/.local/share/gnome-shell/extensions"
TEMP_DIR=$(mktemp -d)

# --- 2. PREREQUISITES ---
if ! command -v gnome-shell &> /dev/null; then
    echo "Error: GNOME Shell is not running or installed."
    exit 1
fi

if ! command -v jq &> /dev/null; then
    echo "Error: 'jq' is required to parse the GNOME Extensions API."
    exit 1
fi

# Get current GNOME Shell version (e.g. 45, 46, 48)
SHELL_VERSION=$(gnome-shell --version | grep -oP '\d+(\.\d+)*' | head -1 | cut -d. -f1)
echo "Detected GNOME Shell version: ${SHELL_VERSION}"

# --- 3. INSTALLATION LOGIC ---
mkdir -p "$EXT_DIR"

for UUID in "${EXTENSIONS[@]}"; do
    echo "-----------------------------------------------"
    echo "Processing: ${UUID}"
    
    # Check if already installed
    if [[ -d "${EXT_DIR}/${UUID}" ]]; then
        echo "Already installed. Skipping..."
        continue
    fi

    # Query API for metadata and download URL using a fallback loop
    # If a new shell version isn't officially supported, fallback to the latest known working one
    DOWNLOAD_PATH=""
    
    # URL Encode the last '@' in the UUID (e.g., for gTile@vov625@gmail.com -> gTile@vov625%40gmail.com)
    API_UUID=$(echo "$UUID" | sed 's/\(.*\)@/\1%40/')
    
    for v in $(seq $SHELL_VERSION -1 42); do
        echo "Querying extensions.gnome.org for ${UUID} (Targeting GNOME $v)..."
        METADATA=$(curl -s "https://extensions.gnome.org/extension-info/?uuid=${API_UUID}&shell_version=${v}")
        
        # Ensure response is JSON and contains download_url
        if [[ "$METADATA" == *"download_url"* ]]; then
            DOWNLOAD_PATH=$(echo "$METADATA" | jq -r '.download_url' 2>/dev/null)
            if [[ "$DOWNLOAD_PATH" != "null" && -n "$DOWNLOAD_PATH" ]]; then
                echo "Found compatible version (tagged for GNOME $v)."
                break
            fi
        fi
    done
    
    if [[ -z "$DOWNLOAD_PATH" || "$DOWNLOAD_PATH" == "null" ]]; then
        echo "Error: Could not find any compatible version map for '${UUID}'."
        continue
    fi

    DOWNLOAD_URL="https://extensions.gnome.org${DOWNLOAD_PATH}"
    echo "Downloading from: ${DOWNLOAD_URL}"
    
    curl -sL "$DOWNLOAD_URL" -o "${TEMP_DIR}/${UUID}.zip"
    
    # Create target directory and extract
    mkdir -p "${EXT_DIR}/${UUID}"
    unzip -q "${TEMP_DIR}/${UUID}.zip" -d "${EXT_DIR}/${UUID}"
    
    # Enable the extension
    echo "Enabling ${UUID}..."
    gnome-extensions enable "${UUID}"
    
    echo "Successfully installed and enabled ${UUID}."
done

# Cleanup
rm -rf "$TEMP_DIR"

echo "-----------------------------------------------"
echo "All done! If extensions don't appear immediately:"
echo "1. Restart GNOME (Alt+F2 -> 'r' on X11, or log out/in on Wayland)."
echo "2. Open 'Extensions' or 'Extension Manager' app to confirm."
