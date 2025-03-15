# GitHub Branch Updater

This repository contains tools and documentation for updating branches across multiple GitHub repositories.

## What's Been Done

1. Created the following branches in your repositories (qmcs, VOTS, vot1):
   - `dev` - Development branch for ongoing work
   - `testing` - Testing branch for QA and validation
   - `feature/updates` - Feature branch for specific updates

2. Added unique documentation to each branch to differentiate them.

3. Created a bash script that can be used to update all branches with the latest changes from the main branch.

## How to Use the Branch Updater Script

### Prerequisites

- Git installed on your system
- Access to your GitHub repositories

### Usage

```bash
# Update specific repositories and branches
./branch-updater.sh --repos qmcs,VOTS,vot1 --branches dev,testing,feature/updates

# Update all configured repositories and branches
./branch-updater.sh --all

# Show help
./branch-updater.sh --help
```

### What the Script Does

1. Clones the specified repositories
2. For each repository, updates the specified branches with the latest changes from the main branch
3. Pushes the updated branches back to GitHub

## Best Practices for Branch Management

1. **Main Branch**: Keep this branch stable and production-ready.
2. **Development Branch**: Use for ongoing development work.
3. **Feature Branches**: Create for specific features or updates.
4. **Testing Branch**: Use for QA and validation before merging to main.

## Automation Options

For more advanced automation, consider:

1. Setting up GitHub Actions to automatically sync branches on a schedule
2. Using webhooks to trigger branch updates when the main branch is updated
3. Implementing a CI/CD pipeline for automated testing and deployment

## Contact

If you have any questions or need assistance with branch management, please reach out.

---

Created: March 15, 2025
