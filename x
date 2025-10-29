#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <filename>"
    exit 1
fi

filename=$1
template="_template.md"
destination="./content/posts/"

if [ ! -d "$destination" ]; then
    mkdir -p "$destination"
fi

cp "$template" "${destination}${filename}.md"
echo "Created ${destination}${filename}.md from $template"
