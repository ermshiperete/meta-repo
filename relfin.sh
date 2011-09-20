#!/bin/bash
# Finish a release
# If no release name is given as parameter the name of the current release branch will be used.

flow=$(git config --get gitflow.prefix.release)
if [ -z $1 ]; then
	branch=$(git symbolic-ref -q HEAD || git name-rev --name-only HEAD 2>/dev/null)
	if [ "$branch" == "${branch#$flow}" ]; then
		echo "ERROR: Either specify the release or switch to a release branch"
		exit 1
	fi
	branch=${branch#refs/heads/$flow}
fi

rel=${1:-$branch}

git checkout develop
git pull --rebase review develop
git checkout master
git pull --rebase review master
git flow release finish $rel
git checkout develop
git pull review develop
git push review --all
git push review --tags :refs/heads/$flow$rel