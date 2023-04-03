#!/usr/bin/env python3

import csv
import json
import genesis_lib as gl

constantine_1_burn_account = "archway19hhsgvxayfs6nqkjqyqt00mrq5r6m4uddd78y5"

with open('../constantine-1/constantine-1-export-1200861.json') as json_file:
  d = json.load(json_file)
  occurances = gl.search_genesis(d, constantine_1_burn_account)
  print(occurances)
  gl.del_account(d, constantine_1_burn_account)
  print(gl.search_genesis(d, constantine_1_burn_account))
  

# write d to a file
with open('../constantine-2/genesis.json', 'w') as outfile:
  json.dump(d, outfile, indent=2)