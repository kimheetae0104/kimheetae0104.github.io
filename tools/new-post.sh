#!/usr/bin/env bash

set -euo pipefail

template=false
body=""
body_file=""
preset=""

usage() {
  echo "Usage: tools/new-post.sh [options] \"Title\" [slug] [date]"
  echo
  echo "Options:"
  echo "  -p, --preset NAME        Apply preset for categories/tags (general, frontend, backend, data)."
  echo "  -t, --template           Use body from POST_TEMPLATE.md (after front matter)."
  echo "  -b, --body TEXT          Inline body content."
  echo "  -B, --body-file PATH     Read body content from file."
  echo "  -h, --help               Show this help message."
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -t | --template)
      template=true
      shift
      ;;
    -p | --preset)
      preset="${2:-}"
      shift 2
      ;;
    -b | --body)
      body="${2:-}"
      shift 2
      ;;
    -B | --body-file)
      body_file="${2:-}"
      shift 2
      ;;
    -h | --help)
      usage
      exit 0
      ;;
    --)
      shift
      break
      ;;
    -*)
      echo "Unknown option: $1"
      usage
      exit 1
      ;;
    *)
      break
      ;;
  esac
done

title="${1:-}"
slug="${2:-}"
post_date="${3:-}"

if [[ -z "$title" ]]; then
  read -r -p "Title: " title
fi

if [[ -z "$title" ]]; then
  echo "Title is required."
  exit 1
fi

if [[ -z "$post_date" ]]; then
  post_date="$(date +%Y-%m-%d)"
fi

if [[ -z "$slug" ]]; then
  slug="$(printf '%s' "$title" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+|-+$//g')"
fi

read -r -p "Categories (comma separated, default: blog): " categories
read -r -p "Tags (comma separated, optional): " tags

default_categories="blog"
default_tags=""

if [[ -n "$preset" ]]; then
  case "$preset" in
    general)
      default_categories="blog"
      default_tags="tech"
      ;;
    frontend)
      default_categories="dev, frontend"
      default_tags="frontend, ui"
      ;;
    backend)
      default_categories="dev, backend"
      default_tags="backend, api"
      ;;
    data)
      default_categories="dev, data"
      default_tags="data, analytics"
      ;;
    *)
      echo "Unknown preset: $preset"
      echo "Available presets: general, frontend, backend, data"
      exit 1
      ;;
  esac
fi

if [[ -z "$categories" ]]; then
  categories="$default_categories"
fi

if [[ -z "$tags" ]]; then
  tags="$default_tags"
fi

categories_list="$(printf '%s' "$categories" | sed -E 's/ *, */, /g')"
tags_list="$(printf '%s' "$tags" | sed -E 's/ *, */, /g')"

file_path="_posts/${post_date}-${slug}.md"

if [[ -e "$file_path" ]]; then
  echo "File already exists: $file_path"
  exit 1
fi

body_content="Write your post content here in Markdown."

if [[ -n "$body_file" ]]; then
  if [[ ! -f "$body_file" ]]; then
    echo "Body file not found: $body_file"
    exit 1
  fi
  body_content="$(cat "$body_file")"
elif [[ -n "$body" ]]; then
  body_content="$body"
elif $template && [[ -f POST_TEMPLATE.md ]]; then
  body_from_template="$(awk 'BEGIN {dash=0} /^---$/ {dash++; next} dash>=2 {print}' POST_TEMPLATE.md)"
  if [[ -n "$body_from_template" ]]; then
    body_content="$body_from_template"
  fi
fi

cat <<EOF > "$file_path"
---
layout: post
title: "$(printf '%s' "$title" | sed 's/"/\\"/g')"
date: ${post_date} 00:00:00 +0900
categories: [${categories_list}]
tags: [${tags_list}]
comments: true
toc: true
---

${body_content}
EOF

echo "Created $file_path"
