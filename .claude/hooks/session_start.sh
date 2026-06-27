#!/usr/bin/env bash
echo "## Repo state at session start"
echo
echo "Branch + working tree:"
git status --short --branch
echo
echo "Last 10 commits:"
git log --oneline -10
