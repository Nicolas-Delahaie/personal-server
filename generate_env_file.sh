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

# Capture variables from YAML lists
yaml_list_vars=$(grep -oE '^[[:space:]]*-[[:space:]]*[A-Z_][A-Z0-9_]*[[:space:]]*$' "$FILE" \
  | sed -E 's/^[[:space:]]*-[[:space:]]*([A-Z_][A-Z0-9_]*)[[:space:]]*$/\1/' \
  | sort -u)

# Merge both sources
all_vars=$(printf "%s\n%s\n" "$variables" "$yaml_list_vars" | sed '/^$/d' | sort -u)

if [ -z "$all_vars" ]; then
    echo "No variables found in $FILE"
    exit 1
fi

cat > "$ENV_FILE" << EOF
# Environment variables generated automatically
# Source file: $FILE
# Generation date: $(date)

EOF

echo "$all_vars" | while read -r var; do
    echo "${var}=" >> "$ENV_FILE"
    echo "- $var"
done

count=$(echo "$all_vars" | wc -l)
echo ""
echo "Success: $count unique variable(s) added to $ENV_FILE"
echo "Edit $ENV_FILE now to set the values"
