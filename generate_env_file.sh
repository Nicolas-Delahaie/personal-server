#!/bin/bash
FILE="compose.yml"
ENV_FILE=".env"

if [ ! -f "$FILE" ]; then
    echo "Error: file '$FILE' does not exist"
    exit 1
fi
if [ -f "$ENV_FILE" ]; then
    echo "Error: file '$ENV_FILE' already exists"
    echo "Remove it or rename it before continuing"
    exit 1
fi
if [ ! -w "." ]; then
    echo "Error: No write permissions in current directory"
    exit 1
fi

echo "Extracting variables from $FILE to $ENV_FILE..."

variables=$(grep -oE '\$\{[^}]+\}' "$FILE" | sed 's/\${\([^}]*\)}/\1/' | sort -u)

if [ -z "$variables" ]; then
    echo "No variables found in $FILE"
    exit 1
fi

cat > "$ENV_FILE" << EOF
# Environment variables generated automatically
# Source file: $FILE
# Generation date: $(date)

EOF

echo "$variables" | while read -r var; do
    echo "${var}=" >> "$ENV_FILE"
    echo "- $var"
done

count=$(echo "$variables" | wc -l)
echo ""
echo "Success: $count unique variable(s) added to $ENV_FILE"
echo "Edit $ENV_FILE now to set the values"