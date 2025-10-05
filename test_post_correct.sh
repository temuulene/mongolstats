#!/usr/bin/bash
# Test POST with CORRECT Mongolian variable codes

URL="https://data.1212.mn/api/v1/en/NSO/Population,%20household/1_Population,%20household/DT_NSO_0300_001V2.px"

# Get cookie
COOKIE=$(curl -s -c - "$URL" | grep rxid | awk '{print $NF}')

# Use MONGOLIAN codes!
QUERY='{
  "query": [
    {"code": "Хүйс", "selection": {"filter": "item", "values": ["0"]}},
    {"code": "Нас", "selection": {"filter": "item", "values": ["0"]}},
    {"code": "Он", "selection": {"filter": "item", "values": ["0"]}}
  ],
  "response": {"format": "json"}
}'

echo "Testing with Mongolian variable codes..."
echo "Query: $QUERY"
echo ""

curl -s -X POST "$URL" \
  -H "Content-Type: application/json" \
  -H "Cookie: rxid=$COOKIE" \
  -d "$QUERY"
