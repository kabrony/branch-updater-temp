#!/bin/bash
# branch-updater.sh - A script to update all branches in selected repositories
# Created: March 15, 2025

# Define colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to display script usage
usage() {
  echo "Usage: $0 [options]"
  echo "Options:"
  echo "  -r, --repos REPO1,REPO2,...  Specify repositories to update (comma-separated)"
  echo "  -b, --branches BRANCH1,BRANCH2,...  Specify branches to update (comma-separated)"
  echo "  -a, --all                    Update all repositories and branches"
  echo "  -h, --help                   Show this help message"
  echo
  echo "Example: $0 --repos qmcs,VOTS,vot1 --branches dev,testing,feature/updates"
  echo "Example: $0 --all"
  exit 1
}

# Function to update a specific branch in a repository
update_branch() {
  local repo=$1
  local branch=$2
  local default_branch=$3
  
  echo -e "${BLUE}Updating branch ${YELLOW}$branch${BLUE} in repository ${YELLOW}$repo${NC}"
  
  # Create a temporary directory
  local temp_dir=$(mktemp -d)
  cd "$temp_dir" || { echo -e "${RED}Failed to create temporary directory${NC}"; return 1; }
  
  # Clone the repository
  echo -e "${BLUE}Cloning repository...${NC}"
  git clone "https://github.com/kabrony/$repo.git" || { echo -e "${RED}Failed to clone repository${NC}"; return 1; }
  cd "$repo" || { echo -e "${RED}Failed to change to repository directory${NC}"; return 1; }
  
  # Update the branch with latest from default branch
  echo -e "${BLUE}Updating branch from $default_branch...${NC}"
  git checkout "$branch" || { echo -e "${RED}Failed to checkout branch $branch${NC}"; return 1; }
  git pull origin "$default_branch" || { echo -e "${RED}Failed to pull latest changes${NC}"; return 1; }
  
  # Push the changes
  echo -e "${BLUE}Pushing updated branch...${NC}"
  git push origin "$branch" || { echo -e "${RED}Failed to push changes${NC}"; return 1; }
  
  echo -e "${GREEN}Successfully updated branch ${YELLOW}$branch${GREEN} in repository ${YELLOW}$repo${NC}"
  
  # Clean up
  cd "$OLDPWD" || true
  rm -rf "$temp_dir"
  
  return 0
}

# Function to get default branch of a repository
get_default_branch() {
  local repo=$1
  # Using GitHub API to get the default branch (requires authentication in a real environment)
  # For this script, we'll use a simple mapping
  
  case "$repo" in
    "qmcs"|"VOTS"|"vot1")
      echo "main"
      ;;
    *)
      echo "main"  # Default to "main" for unknown repos
      ;;
  esac
}

# Default values
ALL=false
REPOS=""
BRANCHES=""

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    -r|--repos)
      REPOS="$2"
      shift 2
      ;;
    -b|--branches)
      BRANCHES="$2"
      shift 2
      ;;
    -a|--all)
      ALL=true
      shift
      ;;
    -h|--help)
      usage
      ;;
    *)
      echo -e "${RED}Unknown option: $1${NC}"
      usage
      ;;
  esac
done

# If --all is specified, set default values
if [ "$ALL" = true ]; then
  REPOS="qmcs,VOTS,vot1"
  BRANCHES="dev,testing,feature/updates"
fi

# Check if required parameters are provided
if [ -z "$REPOS" ] || [ -z "$BRANCHES" ]; then
  echo -e "${RED}Error: Repositories and branches must be specified${NC}"
  usage
fi

# Convert comma-separated strings to arrays
IFS=',' read -r -a REPO_ARRAY <<< "$REPOS"
IFS=',' read -r -a BRANCH_ARRAY <<< "$BRANCHES"

echo -e "${GREEN}Starting branch update process...${NC}"
echo -e "${BLUE}Repositories: ${YELLOW}${REPO_ARRAY[*]}${NC}"
echo -e "${BLUE}Branches: ${YELLOW}${BRANCH_ARRAY[*]}${NC}"
echo

# Process each repository and branch
for repo in "${REPO_ARRAY[@]}"; do
  default_branch=$(get_default_branch "$repo")
  echo -e "${BLUE}Processing repository ${YELLOW}$repo${BLUE} (default branch: ${YELLOW}$default_branch${BLUE})${NC}"
  
  for branch in "${BRANCH_ARRAY[@]}"; do
    update_branch "$repo" "$branch" "$default_branch"
  done
  
  echo
done

echo -e "${GREEN}Branch update process completed!${NC}"
