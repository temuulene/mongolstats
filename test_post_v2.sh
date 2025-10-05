#!/usr/bin/bash
# Test different POST query formats

URL="https://data.1212.mn/api/v1/en/NSO/Population,%20household/1_Population,%20household/DT_NSO_0300_001V2.px"

# Get cookie
COOKIE=$(curl -s -c - "$URL" | grep rxid | awk '{print $NF}')

# Try JSON-stat2 format (what code requests)
QUERY_JSONSTAT='{
  "query": [
    {"code": "Sex", "selection": {"filter": "item", "values": ["0"]}},
    {"code": "Age", "selection": {"filter": "item", "values": ["0"]}},
    {"code": "Year", "selection": {"filter": "item", "values": ["0"]}}
  ],
  "response": {"format": "json-stat2"}
}'

echo "Test 1: JSON-stat2 format"
curl -s -X POST "$URL" \
  -H "Content-Type: application/json" \
  -H "Cookie: rxid=$COOKIE" \
  -d "$QUERY_JSONSTAT" | head -50
echo ""
echo "---"

# Try px format
QUERY_PX='{
  "query": [
    {"code": "Sex", "selection": {"filter": "item", "values": ["0"]}},
    {"code": "Age", "selection": {"filter": "item", "values": ["0"]}},
    {"code": "Year", "selection": {"filter": "item", "values": ["0"]}}
  ],
  "response": {"format": "px"}
}'

echo ""
echo "Test 2: px format"
curl -s -X POST "$URL" \
  -H "Content-Type: application/json" \
  -H "Cookie: rxid=$COOKIE" \
  -d "$QUERY_PX" | head -50
echo ""
echo "---"

# Try without response format
QUERY_SIMPLE='{
  "query": [
    {"code": "Sex", "selection": {"filter": "item", "values": ["0"]}},
    {"code": "Age", "selection": {"filter": "item", "values": ["0"]}},
    {"code": "Year", "selection": {"filter": "item", "values": ["0"]}}
  ]
}'

echo ""
echo "Test 3: No response format specified"
curl -s -X POST "$URL" \
  -H "Content-Type: application/json" \
  -H "Cookie: rxid=$COOKIE" \
  -d "$QUERY_SIMPLE" | head -50
