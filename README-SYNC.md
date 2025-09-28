# Obsidian Vault to Quartz Sync Setup

This repository is configured to sync content from your Obsidian vault to Quartz for publishing. Since symbolic links don't work well with GitHub, we've implemented an automated sync solution.

## Setup Instructions

### 1. Configure Your Obsidian Vault Path

Edit the path in both sync files to point to your Obsidian vault's publish folder:

**In `sync-content.sh`:**
```bash
DEFAULT_OBSIDIAN_PATH="$HOME/path/to/your/obsidian/vault/publish"
```

**In `.git/hooks/pre-commit`:**
```bash
OBSIDIAN_PUBLISH_PATH="$HOME/path/to/your/obsidian/vault/publish"
```

Replace `$HOME/path/to/your/obsidian/vault/publish` with the actual path to the folder in your Obsidian vault that you want to publish.

### 2. Manual Sync

To manually sync your Obsidian content to Quartz:

```bash
./sync-content.sh
```

Or specify a custom path:
```bash
./sync-content.sh /path/to/your/obsidian/vault/publish
```

### 3. Automatic Sync on Commit

The pre-commit hook will automatically sync your content before each commit. This ensures your published content is always up-to-date when you push to GitHub.

## Workflow

1. **Write in Obsidian**: Create and edit your notes in your Obsidian vault
2. **Sync Content**: Run `./sync-content.sh` or let the pre-commit hook handle it
3. **Build and Deploy**: 
   ```bash
   npx quartz build
   git add .
   git commit -m "Update content"
   git push
   ```

## Features

- ✅ **Automatic syncing** before each commit
- ✅ **Manual sync option** with the sync script
- ✅ **Backup creation** before overwriting content
- ✅ **Exclusion of Obsidian metadata** (.obsidian folder, .DS_Store, etc.)
- ✅ **Efficient syncing** using rsync with delete option
- ✅ **Error handling** and user-friendly messages

## Troubleshooting

### Pre-commit Hook Not Working

If the pre-commit hook isn't running:
1. Check if it's executable: `ls -la .git/hooks/pre-commit`
2. Make it executable: `chmod +x .git/hooks/pre-commit`

### Path Issues

If you get "folder not found" errors:
1. Update the paths in both `sync-content.sh` and `.git/hooks/pre-commit`
2. Use absolute paths (starting with `/` or `$HOME`)
3. Test the path: `ls -la /your/obsidian/vault/path`

### Content Not Syncing

1. Check if your Obsidian publish folder exists and contains `.md` files
2. Run the sync script manually to see detailed output
3. Verify file permissions on both source and destination folders

## Alternative: Symbolic Links (Advanced)

If you want to try symbolic links despite GitHub limitations:

```bash
# Remove current content folder
rm -rf content

# Create symbolic link
ln -s /path/to/your/obsidian/vault/publish content

# Configure Git to follow symlinks
git config core.symlinks true
```

**Note**: This approach has limitations with GitHub Pages and some CI/CD systems.