#!/usr/bin/env python3
"""
Add DT_NSO_0300_001V2 to px_index.json
This is a quick fix while we prepare for full index rebuild
"""

import json
import sys

# Read current index
with open('inst/extdata/px_index.json', 'r', encoding='utf-8') as f:
    index = json.load(f)

print(f"Current index has {len(index)} entries")

# Check if DT_NSO_0300_001V2 already exists
exists = any(entry.get('tbl_id') == 'DT_NSO_0300_001V2' for entry in index)

if exists:
    print("✓ DT_NSO_0300_001V2 already in index")
    sys.exit(0)

print("✗ DT_NSO_0300_001V2 missing - adding it now...")

# Add the missing entry based on API metadata
new_entry = {
    "px_path": "Population, household/1_Population, household",
    "px_file": "DT_NSO_0300_001V2.px",
    "tbl_id": "DT_NSO_0300_001V2",
    "tbl_eng_nm": "RESIDENT POPULATION IN MONGOLIA, by sex, single year of age, and by year",
    "tbl_nm": "МОНГОЛ УЛСЫН ОРШИН СУУГЧ ХҮНАМЖ, хүйс, нас, жилээр",
    "strt_prd": "2024",
    "end_prd": "2000"
}

# Insert at beginning for visibility
index.insert(0, new_entry)

# Write back
with open('inst/extdata/px_index.json', 'w', encoding='utf-8') as f:
    json.dump(index, f, ensure_ascii=False)

print(f"✓ Added! New index has {len(index)} entries")
print("✓ File saved: inst/extdata/px_index.json")
