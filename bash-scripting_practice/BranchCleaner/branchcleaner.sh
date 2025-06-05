#!/bin/bash

####################################################
# This script deletes merged Git branches safely.  #
# Supports both local and remote cleanup.          #
####################################################

set -e  # Exit on error

# === Globals ===
BASE_BRANCH="main"
PROTECTED_BRANCHES=("main" "master" "develop")

# === Functions ===
set_base_branch() {
    echo ""
    current_branch=$(git rev-parse --abbrev-ref HEAD)
    if [[ "$current_branch" != "$BASE_BRANCH" ]]; then
        echo "Switching to $BASE_BRANCH to ensure safe deletion..."
        git checkout "$BASE_BRANCH" --quiet
    else
        echo "Already on '$BASE_BRANCH'"
    fi

    if ! git diff-index --quiet HEAD --; then
        echo "Warning: Uncommitted changes detected."
    fi
}


fetch_remote_branches() {
    echo ""
    echo "Fetching latest remote branches..."
    git fetch -p
}

get_local_merged_branches() {
    echo ""
    echo "Finding merged local branches..."
    
    MERGED_LOCAL=$(git branch -r --merged "origin/$BASE_BRANCH" \
        | grep origin/ \
        | grep -vE "origin/($(IFS=\|; echo "${PROTECTED_BRANCHES[*]}"))" )

    echo "Merged local branches:"
    echo "$MERGED_LOCAL"
    echo ""
}

get_remote_merged_branches() {
    echo ""
    echo "Finding merged remote branches..."
    
    MERGED_REMOTE=$(git branch -r --merged "origin/$BASE_BRANCH" \
        | grep origin/ \
        | grep -vE "origin/($(IFS=\|; echo "${PROTECTED_BRANCHES[*]}"))")

    echo "Merged remote branches:"
    echo "$MERGED_REMOTE"
    echo ""
}

delete_local_merged_branches() {
    read -p "Delete these local branches? (y/N) " confirm_local < /dev/tty
    if [[ "$confirm_local" == "y" ]]; then
        while IFS= read -r branch; do
            branch=$(echo "$branch" | xargs)
            [[ -z "$branch" ]] && continue
            echo "Deleting local branch: $branch"
            git branch -d "$branch"
        done <<< "$MERGED_LOCAL"
    else
        echo "Skipping local branch deletion."
    fi
}

delete_remote_merged_branches() {
    read -p "Delete these remote branches? (y/N) " confirm_remote < /dev/tty
    if [[ "$confirm_remote" == "y" ]]; then
        while IFS= read -r remote_branch; do
            remote_branch=$(echo "$remote_branch" | xargs)
            [[ -z "$remote_branch" ]] && continue
            branch_name=$(echo "$remote_branch" | sed 's|origin/||' | xargs)
            echo "Deleting remote branch: $branch_name"
            git push origin --delete "$branch_name"
        done <<< "$MERGED_REMOTE"
    else
        echo "Skipping remote branch deletion."
    fi
}
# === Main ===

set_base_branch
fetch_remote_branches

echo ""
read -p "Delete (l)ocal or (r)emote branches? " branch_type
case "$branch_type" in
    l|L|local)
        get_local_merged_branches
        delete_local_merged_branches
        ;;
    r|R|remote)
        get_remote_merged_branches
        delete_remote_merged_branches
        ;;
    *)
        echo "Invalid option."
        exit 1
        ;;
esac

echo "Done."
