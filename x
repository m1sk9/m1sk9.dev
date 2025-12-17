#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <filename>"
    exit 1
fi

post_name=$1
template="_template.md"
destination="./content/posts/${post_name}"

if [ ! -d "$destination" ]; then
    mkdir -p "$destination"
fi

cp "$template" "${destination}/index.md"
echo "Created ${destination}/index.md from $template"
