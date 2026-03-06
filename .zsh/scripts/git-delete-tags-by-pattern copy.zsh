#!/bin/zsh

# Check if a pattern is provided
if [ -z "$1" ]; then
  echo "Usage: gtd <pattern>"
  echo "Please provide a pattern to match tags."
  exit 1
fi

PATTERN=$1

# Delete tags remotely
echo "Deleting remote tags matching pattern: $PATTERN"
git tag | grep "$PATTERN" | xargs -r -I {} git push origin --delete {}

# Delete tags locally
echo "Deleting local tags matching pattern: $PATTERN"
git tag | grep "$PATTERN" | xargs -r git tag -d


echo "Done!"
