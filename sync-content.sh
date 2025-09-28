#!/bin/bash

# Sync script for Obsidian vault content to Quartz
# Usage: ./sync-content.sh [obsidian-publish-path]

set -e

# Default Obsidian publish path (update this to your actual path)
DEFAULT_OBSIDIAN_PATH="$HOME/Documents/Obsidian Vault/publish"

# Use provided path or default
OBSIDIAN_PUBLISH_PATH="${1:-$DEFAULT_OBSIDIAN_PATH}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Quartz Content Sync Script${NC}"
echo "================================"

# Check if we're in a Quartz repository
if [ ! -f "quartz.config.ts" ]; then
    echo -e "${RED}Error: This doesn't appear to be a Quartz repository${NC}"
    echo "Please run this script from your Quartz root directory"
    exit 1
fi

# Check if the Obsidian publish folder exists
if [ ! -d "$OBSIDIAN_PUBLISH_PATH" ]; then
    echo -e "${RED}Error: Obsidian publish folder not found at: $OBSIDIAN_PUBLISH_PATH${NC}"
    echo ""
    echo "Please either:"
    echo "1. Update the DEFAULT_OBSIDIAN_PATH in this script"
    echo "2. Run: ./sync-content.sh /path/to/your/obsidian/vault/publish"
    exit 1
fi

# Create content directory if it doesn't exist
mkdir -p content

# Backup existing content if it exists and is not empty
if [ -d "content" ] && [ "$(ls -A content)" ]; then
    BACKUP_DIR="content.backup.$(date +%Y%m%d_%H%M%S)"
    echo -e "${YELLOW}Backing up existing content to: $BACKUP_DIR${NC}"
    cp -r content "$BACKUP_DIR"
fi

# Sync content from Obsidian vault to Quartz content folder
echo -e "${YELLOW}Syncing content from: $OBSIDIAN_PUBLISH_PATH${NC}"
echo -e "${YELLOW}To: $(pwd)/content${NC}"

# Use rsync for efficient syncing
rsync -av --delete \
    --exclude='.DS_Store' \
    --exclude='.obsidian' \
    --exclude='*.tmp' \
    --exclude='Thumbs.db' \
    "$OBSIDIAN_PUBLISH_PATH/" content/

echo -e "${GREEN}✓ Content synced successfully!${NC}"

# Show what was synced
echo ""
echo "Synced files:"
find content -type f -name "*.md" | head -10
if [ $(find content -type f -name "*.md" | wc -l) -gt 10 ]; then
    echo "... and $(( $(find content -type f -name "*.md" | wc -l) - 10 )) more files"
fi

echo ""
echo -e "${GREEN}Next steps:${NC}"
echo "1. Review the synced content in the 'content' folder"
echo "2. Run 'npx quartz build' to build your site"
echo "3. Commit and push your changes to deploy"