#!/usr/bin/bash
# Check the exact structure of the JSON response

URL="https://data.1212.mn/api/v1/en/NSO/Population,%20household/1_Population,%20household/DT_NSO_0300_001V2.px"

COOKIE=$(curl -s -c - "$URL" | grep rxid | awk '{print $NF}')

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
}' | python3 -c "import sys, json; d=json.load(sys.stdin); print('COLUMNS:'); print(json.dumps(d['columns'], indent=2)); print('\nDATA:'); print(json.dumps(d['data'], indent=2))"
