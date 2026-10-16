#!/bin/bash

# The __NN__ prefix orders category groups on the posts index.
# A case statement is used because macOS ships bash 3.2, which lacks associative arrays.
category_label() {
    case "$1" in
        minecraft)      echo "__01__Minecraft" ;;
        security)       echo "__02__Security" ;;
        infrastructure) echo "__03__Infrastructure" ;;
        firefox)        echo "__04__Firefox" ;;
        tooling)        echo "__05__Tooling" ;;
        *)              return 1 ;;
    esac
}

usage_categories="minecraft security infrastructure firefox tooling"

if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
    echo "Usage: $0 <filename> [category]"
    echo "Categories: ${usage_categories}"
    exit 1
fi

post_name=$1
category=$2
template="_template.md"
destination="./content/posts/${post_name}"

if [ -n "$category" ]; then
    if ! label=$(category_label "$category"); then
        echo "Unknown category: ${category}"
        echo "Categories: ${usage_categories}"
        exit 1
    fi
fi

if [ ! -d "$destination" ]; then
    mkdir -p "$destination"
fi

if [ -n "$category" ]; then
    sed "s/^categories = \[\"\"\]/categories = [\"${label}\"]/" "$template" > "${destination}/index.md"
else
    cp "$template" "${destination}/index.md"
fi
echo "Created ${destination}/index.md from $template"
