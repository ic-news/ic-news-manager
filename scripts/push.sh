#!/bin/bash
# Default commit message
COMMIT="Default commit message"

# Parse command line arguments
while getopts "m:" opt; do
  case $opt in
    m)
      COMMIT="$OPTARG"
      ;;
    ?)
      echo "Usage: $0 -m \"commit message\""
      exit 1
      ;;
  esac
done

# Configure Git global user information
git config user.name "emily-atson"
git config user.email "anoshufu@gmail.com"

# Configure GitHub CLI (gh) authentication
gh auth switch -u emily-atson
gh auth setup-git

# Add all changes
git add .

# Commit changes
if [ -n "$COMMIT" ]; then
  git commit -m "$COMMIT"
else
  echo "Error: Commit message is empty, please use -m to specify a message"
  exit 1
fi

# Push to remote repository (assuming branch is main)
git push -u origin main