#!/bin/bash

# Convert comma-separated CORS_ORIGINS to YAML array format
if [ -n "$CORS_ORIGINS" ]; then
    echo "Configuring CORS origins: $CORS_ORIGINS"
    
    # Split CORS_ORIGINS by comma and format as YAML array
    IFS=',' read -ra ORIGINS <<< "$CORS_ORIGINS"
    
    # Create a temporary file with the YAML origins
    TEMP_FILE=$(mktemp)
    for origin in "${ORIGINS[@]}"; do
        # Trim whitespace using parameter expansion
        origin="${origin#"${origin%%[![:space:]]*}"}"  # Remove leading whitespace
        origin="${origin%"${origin##*[![:space:]]}"}"  # Remove trailing whitespace
        echo "        - ${origin}" >> "$TEMP_FILE"
    done
    
    # Use awk to replace the placeholder while preserving backslashes
    awk -v origins_file="$TEMP_FILE" '
        /{{CORS_ORIGINS}}/ {
            while ((getline line < origins_file) > 0) {
                print line
            }
            close(origins_file)
            next
        }
        {print}
    ' /etc/kong/kong.yml.template > /etc/kong/kong.yml
    
    # Clean up
    rm "$TEMP_FILE"

else
    echo "No CORS_ORIGINS specified, using template as-is"
    cp /etc/kong/kong.yml.template /etc/kong/kong.yml
fi

# Validate the generated configuration
echo "Validating Kong configuration..."
kong config parse /etc/kong/kong.yml

if [ $? -eq 0 ]; then
    echo "Configuration is valid. Starting Kong..."
    exec /docker-entrypoint.sh kong docker-start
else
    echo "Kong configuration validation failed!"
    exit 1
fi