#!/bin/bash

if [ -z "$1" ];
then
    echo "No destination provided."
    exit 1
fi

if [ -d "$1" ];
then
    cd "$1"
    echo "Removing existing files..."
    echo ""
    rm * -rf
    cd ..
fi

echo "Regenerating site..."
hugo -d "$1"

echo ""
cd "$1"
git add -A
git commit -m "Site updated at `date --iso-8601=seconds`"

read -p "Deploy to Github? " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]];
then
    git push
fi

