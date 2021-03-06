#!/bin/bash
# Finish a support branch
# (equivalent to missing 'git flow support finish' command)

developConfig=$(git config --get gitflow.branch.develop)
originConfig=$(git config --get gitflow.origin)
develop=${developConfig:-develop}
origin=${originConfig:-origin}

if [ -z $1 ]; then
	echo "Usage: git supfin <release>"
	exit 1
fi

branch=$(git symbolic-ref -q HEAD || git name-rev --name-only HEAD 2>/dev/null)
branch=${branch#refs/heads/}

if [ "$branch" == "${branch#$(git config --get gitflow.prefix.support)}" ]; then
	echo "Need to be on support branch"
	exit 1
fi

git pull --rebase $origin $branch
git tag -a $1
git checkout $develop
git pull --rebase $origin $develop
git merge -m 'Merge branch "$branch" into $develop' --no-ff $branch
git push $origin --all
git push $origin --tags

