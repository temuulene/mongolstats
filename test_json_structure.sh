#!/usr/bin/bash
# Test different JSON structures to find what PXWeb accepts

URL="https://data.1212.mn/api/v1/en/NSO/Population,%20household/1_Population,%20household/DT_NSO_0300_001V2.px"

# Get cookie
COOKIE=$(curl -s -c - "$URL" | grep rxid | awk '{print $NF}')
echo "Cookie: rxid=$COOKIE"
echo ""

# Test 1: Our current format with lowercase json
echo "Test 1: filter='item', format='json'"
curl -s -X POST "$URL" \
  -H "Content-Type: application/json" \
  -H "Cookie: rxid=$COOKIE" \
  -d '{
  "query": [
    {"code": "Хүйс", "selection": {"filter": "item", "values": ["0"]}},
    {"code": "Нас", "selection": {"filter": "item", "values": ["0"]}},
    {"code": "Он", "selection": {"filter": "item", "values": ["0"]}}
  ],
  "response": {"format": "json"}
}' | head -50
echo -e "\n---\n"

# Test 2: Without filter field
echo "Test 2: No filter, just values"
curl -s -X POST "$URL" \
  -H "Content-Type: application/json" \
  -H "Cookie: rxid=$COOKIE" \
  -d '{
  "query": [
    {"code": "Хүйс", "selection": {"values": ["0"]}},
    {"code": "Нас", "selection": {"values": ["0"]}},
    {"code": "Он", "selection": {"values": ["0"]}}
  ],
  "response": {"format": "json"}
}' | head -50
echo -e "\n---\n"

# Test 3: filter='all' instead of 'item'
echo "Test 3: filter='all'"
curl -s -X POST "$URL" \
  -H "Content-Type: application/json" \
  -H "Cookie: rxid=$COOKIE" \
  -d '{
  "query": [
    {"code": "Хүйс", "selection": {"filter": "all"}},
    {"code": "Нас", "selection": {"filter": "all"}},
    {"code": "Он", "selection": {"filter": "all"}}
  ],
  "response": {"format": "json"}
}' | head -50
echo -e "\n---\n"

# Test 4: Try json-stat format
echo "Test 4: format='json-stat'"
curl -s -X POST "$URL" \
  -H "Content-Type: application/json" \
  -H "Cookie: rxid=$COOKIE" \
  -d '{
  "query": [
    {"code": "Хүйс", "selection": {"filter": "item", "values": ["0"]}},
    {"code": "Нас", "selection": {"filter": "item", "values": ["0"]}},
    {"code": "Он", "selection": {"filter": "item", "values": ["0"]}}
  ],
  "response": {"format": "json-stat"}
}' | head -50
