#!/bin/bash

# Test Authentication and Cookie Response Script
# This script tests the login endpoint and checks if cookies are being returned

# Configuration - Update these values as needed
BASE_URL="http://localhost:8080"  # Change this to your backend URL
LOGIN_ENDPOINT="/v2/auth/login"
EMAIL="your-email@example.com"     # Replace with actual email
PASSWORD="your-password"           # Replace with actual password

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Authentication Cookie Test ===${NC}"
echo -e "${YELLOW}Testing login endpoint: ${BASE_URL}${LOGIN_ENDPOINT}${NC}"
echo -e "${YELLOW}Email: ${EMAIL}${NC}"
echo ""

# Test 1: Basic login with cookie tracking
echo -e "${BLUE}Test 1: Basic login with cookie tracking${NC}"
echo "curl -X POST ${BASE_URL}${LOGIN_ENDPOINT} \\"
echo "  -H 'Content-Type: application/json' \\"
echo "  -d '{\"email\":\"${EMAIL}\",\"password\":\"${PASSWORD}\"}' \\"
echo "  -c cookies.txt \\"
echo "  -v"
echo ""

RESPONSE=$(curl -X POST "${BASE_URL}${LOGIN_ENDPOINT}" \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"${EMAIL}\",\"password\":\"${PASSWORD}\"}" \
  -c cookies.txt \
  -v 2>&1)

echo -e "${GREEN}Response:${NC}"
echo "$RESPONSE"
echo ""

# Check if cookies.txt was created and has content
if [ -f "cookies.txt" ] && [ -s "cookies.txt" ]; then
    echo -e "${GREEN}✓ Cookies found and saved to cookies.txt${NC}"
    echo -e "${BLUE}Cookie contents:${NC}"
    cat cookies.txt
else
    echo -e "${RED}✗ No cookies found or cookies.txt is empty${NC}"
fi
echo ""

# Test 2: Check Set-Cookie headers in response
echo -e "${BLUE}Test 2: Check Set-Cookie headers in response${NC}"
echo "curl -X POST ${BASE_URL}${LOGIN_ENDPOINT} \\"
echo "  -H 'Content-Type: application/json' \\"
echo "  -d '{\"email\":\"${EMAIL}\",\"password\":\"${PASSWORD}\"}' \\"
echo "  -D headers.txt \\"
echo "  -s"
echo ""

curl -X POST "${BASE_URL}${LOGIN_ENDPOINT}" \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"${EMAIL}\",\"password\":\"${PASSWORD}\"}" \
  -D headers.txt \
  -s > response_body.json

if [ -f "headers.txt" ]; then
    echo -e "${GREEN}Response headers saved to headers.txt${NC}"
    echo -e "${BLUE}Set-Cookie headers:${NC}"
    grep -i "set-cookie" headers.txt || echo -e "${YELLOW}No Set-Cookie headers found${NC}"
    echo ""
    echo -e "${BLUE}All headers:${NC}"
    cat headers.txt
else
    echo -e "${RED}Failed to save headers${NC}"
fi
echo ""

# Test 3: Check response body
if [ -f "response_body.json" ]; then
    echo -e "${BLUE}Response body:${NC}"
    cat response_body.json
    echo ""
fi

# Test 4: Test with invalid credentials to compare
echo -e "${BLUE}Test 4: Test with invalid credentials for comparison${NC}"
INVALID_RESPONSE=$(curl -X POST "${BASE_URL}${LOGIN_ENDPOINT}" \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"invalid@example.com\",\"password\":\"wrongpassword\"}" \
  -c invalid_cookies.txt \
  -v 2>&1)

echo -e "${GREEN}Invalid credentials response:${NC}"
echo "$INVALID_RESPONSE"
echo ""

if [ -f "invalid_cookies.txt" ] && [ -s "invalid_cookies.txt" ]; then
    echo -e "${YELLOW}Note: Cookies were set even with invalid credentials${NC}"
    cat invalid_cookies.txt
else
    echo -e "${GREEN}No cookies set with invalid credentials (expected)${NC}"
fi
echo ""

# Cleanup
echo -e "${BLUE}Cleaning up temporary files...${NC}"
rm -f cookies.txt headers.txt response_body.json invalid_cookies.txt

echo -e "${BLUE}=== Test Complete ===${NC}"
echo ""
echo -e "${YELLOW}Summary:${NC}"
echo "1. Check if Set-Cookie headers are present in the response"
echo "2. Verify cookie attributes (secure, httpOnly, sameSite)"
echo "3. Confirm cookies are only set on successful authentication"
echo "4. Test with your actual email and password" 