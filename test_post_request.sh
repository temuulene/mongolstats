#!/usr/bin/bash
# Test PXWeb POST request

URL="https://data.1212.mn/api/v1/en/NSO/Population,%20household/1_Population,%20household/DT_NSO_0300_001V2.px"

# First GET to seed cookie
echo "Step 1: GET metadata to seed cookie..."
COOKIE=$(curl -s -c - "$URL" | grep rxid | awk '{print $NF}')
echo "Cookie: rxid=$COOKIE"

# Build query JSON
QUERY='{
  "query": [
    {"code": "Sex", "selection": {"filter": "item", "values": ["0"]}},
    {"code": "Age", "selection": {"filter": "item", "values": ["0"]}},
    {"code": "Year", "selection": {"filter": "item", "values": ["0"]}}
  ],
  "response": {"format": "JSON"}
}'

echo ""
echo "Step 2: POST data request with cookie..."
echo "Query: $QUERY"
echo ""

if [ -n "$COOKIE" ]; then
  curl -s -X POST "$URL" \
    -H "Content-Type: application/json" \
    -H "Cookie: rxid=$COOKIE" \
    -d "$QUERY" | head -200
else
  curl -s -X POST "$URL" \
    -H "Content-Type: application/json" \
    -d "$QUERY" | head -200
fi
