#!/usr/bin/env bash

set -euo pipefail

max_width=""
quality=""
output_dir=""
name=""

usage() {
  echo "Usage: tools/add-image.sh [options] /path/to/image [date]"
  echo
  echo "Options:"
  echo "  -w, --max-width PX       Resize to max width (keeps aspect ratio)."
  echo "  -q, --quality N          JPEG quality 1-100 (only for jpg/jpeg)."
  echo "  -o, --output-dir DIR     Output directory (default: assets/img/posts/DATE)."
  echo "  -n, --name NAME          Override output filename."
  echo "  -h, --help               Show this help message."
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -w | --max-width)
      max_width="${2:-}"
      shift 2
      ;;
    -q | --quality)
      quality="${2:-}"
      shift 2
      ;;
    -o | --output-dir)
      output_dir="${2:-}"
      shift 2
      ;;
    -n | --name)
      name="${2:-}"
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

input_path="${1:-}"
post_date="${2:-}"

if [[ -z "$input_path" ]]; then
  echo "Image path is required."
  usage
  exit 1
fi

if [[ ! -f "$input_path" ]]; then
  echo "File not found: $input_path"
  exit 1
fi

if [[ -z "$post_date" ]]; then
  post_date="$(date +%Y-%m-%d)"
fi

if [[ -z "$output_dir" ]]; then
  output_dir="assets/img/posts/${post_date}"
fi

mkdir -p "$output_dir"

basename="$(basename "$input_path")"
safe_name="$(printf '%s' "${name:-$basename}" | tr ' ' '-')"
output_path="${output_dir}/${safe_name}"

cp "$input_path" "$output_path"

if command -v sips >/dev/null 2>&1; then
  if [[ -n "$max_width" ]]; then
    sips -Z "$max_width" "$output_path" >/dev/null
  fi
  if [[ -n "$quality" ]]; then
    ext="${output_path##*.}"
    ext_lower="$(printf '%s' "$ext" | tr '[:upper:]' '[:lower:]')"
    if [[ "$ext_lower" == "jpg" || "$ext_lower" == "jpeg" ]]; then
      sips -s formatOptions "$quality" "$output_path" >/dev/null
    else
      echo "Quality option is only applied to jpg/jpeg files."
    fi
  fi
else
  if [[ -n "$max_width" || -n "$quality" ]]; then
    echo "sips is not available; resize/quality options were skipped."
  fi
fi

site_path="/${output_path}"
echo "Saved ${output_path}"
echo "Use: ![](${site_path})"
