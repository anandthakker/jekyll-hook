#!/bin/bash
set -e

# This script is meant to be run automatically
# as part of the jekyll-hook application.
# https://github.com/developmentseed/jekyll-hook

repo=$1
branch=$2
owner=$3
giturl=$4
source=$5
build=$6

# Check to see if repo exists. If not, git clone it
if [ ! -d $source ]; then
    git clone $giturl $source
fi

# Git checkout appropriate branch, pull latest code
cd $source
git checkout $branch
git pull origin $branch
cd -

# Run jekyll
cd $source
jekyll build -s $source -d $build
cd -

# Prerender the math
if [ ! -d $build/books-prerendered ]; then
  mkdir $build/books-prerendered
fi
for filename in $build/books/*.html; do
  ./node_modules/MathJax-node/bin/page2mml < "$filename" > "$build/books-prerendered/`basename $filename`";
done
