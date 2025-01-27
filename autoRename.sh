#!/bin/bash

# Configuration
TARGET_DIR="$HOME/Pictures/MyWallpapers" # Replace with your target directory
GIT_DIR="$HOME/Pictures/MyWallpapers"    # Replace with your Git repo directory
EXTENSIONS="png"                         # Supported extensions
BRANCH="master"                          # Target Git branch
DATE=$(date +'%Y-%m-%d %H:%M:%S')

# Function to rename files
rename_files() {
	echo "Renaming files in $TARGET_DIR..."

	let i1=1
	for file in $(ls | grep -v autoRename.sh | grep -v README); do
		[ -f $file ] && mv $file $(printf "%09d" $i1).png && let i1=i1+1
	done

	let i2=1

	for file in $(ls -tr | grep -v autoRename.sh | grep -v README); do
		[ -f $file ] && mv $file $(printf "%02d" $i2).png && let i2=i2+1
	done

	echo '## wallpapers' >README.md
	for file in $(ls | grep -v autoRename.sh | grep -v README); do
		echo "$file  " >>README.md
		echo "![$file]($file)" >>README.md
	done
}

# Function to push changes to Git
push_to_git() {
	echo "Pushing changes to Git..."
	cd "$GIT_DIR" || {
		echo "Failed to navigate to $GIT_DIR"
		exit 1
	}

	# Check if there are changes
	if git status --porcelain | grep -qE "^\s*[AMDR]"; then
		git add .
		git commit -m "AutoRename: updated images on $DATE"
		git push origin "$BRANCH"
		echo "Changes pushed to remote repo on branch '$BRANCH'."
	else
		echo "No changes detected. Nothing to push."
	fi
}

# Main script execution
echo "Starting AutoRename process..."
rename_files
push_to_git
echo "AutoRename process complete!"
