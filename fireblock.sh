#!/bin/bash

LOCATION=".mozilla/firefox/distribution/policies.json"
# LOCATION="/etc/firefox/policies/policies.json" # System-wide setting

POLICY_FILE="$HOME/$LOCATION"

# Ensure the policy file exists
mkdir -p "$(dirname "$POLICY_FILE")"
if [[ ! -f "$POLICY_FILE" ]]; then
    echo '{ "policies": { "WebsiteFilter": { "Block": [], "Exceptions": [] } } }' > "$POLICY_FILE"
fi

# Read the existing policies
BLOCKED_SITES=$(jq -r '.policies.WebsiteFilter.Block // []' "$POLICY_FILE")
EXCEPTIONS=$(jq -r '.policies.WebsiteFilter.Exceptions // []' "$POLICY_FILE")

# Parse arguments (check for flags)
ADD_EXCEPTIONS=false
SITES=()
while [[ "$#" -gt 0 ]]; do
    case "$1" in
        -e)
            ADD_EXCEPTIONS=true
            ;;
        *)
            SITES+=("$1")
            ;;
    esac
    shift
done

# Add sites to the appropriate list, avoiding duplicates
for SITE in "${SITES[@]}"; do
    if [ "$ADD_EXCEPTIONS" = true ]; then
        if ! echo "$EXCEPTIONS" | grep -q "$SITE"; then
            EXCEPTIONS=$(echo "$EXCEPTIONS" | jq ". + [\"$SITE\"]")
        fi
    else
        if ! echo "$BLOCKED_SITES" | grep -q "$SITE"; then
            BLOCKED_SITES=$(echo "$BLOCKED_SITES" | jq ". + [\"$SITE\"]")
        fi
    fi
done

# Write updated policies back
jq ".policies.WebsiteFilter.Block = $BLOCKED_SITES | .policies.WebsiteFilter.Exceptions = $EXCEPTIONS" "$POLICY_FILE" > "${POLICY_FILE}.tmp" && mv "${POLICY_FILE}.tmp" "$POLICY_FILE"

echo "Updated policies in $POLICY_FILE"
