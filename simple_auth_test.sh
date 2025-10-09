#!/bin/bash

# Simple Authentication Test with curl
# Replace the email and password with your actual credentials

echo "Testing authentication endpoint..."

# Simple curl command to test login and check for cookies
curl -X POST "http://localhost:8080/v2/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"email":"your-email@example.com","password":"your-password"}' \
  -c cookies.txt \
  -v

echo ""
echo "Cookies saved to cookies.txt:"
if [ -f "cookies.txt" ]; then
    cat cookies.txt
else
    echo "No cookies file created"
fi 