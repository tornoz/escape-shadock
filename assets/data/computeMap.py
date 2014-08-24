#!/bin/python

import sys

f = open(sys.argv[1], 'r+')
data = f.readlines();
for i in range(12):
 data.pop(0)
finalMap = []

for line in data:
 lineArray = []
 for number in line.split(","):
  if number != '\n':
   lineArray.append(str(int(number)-1))
 finalMap.append(','.join(lineArray))
f= open(sys.argv[2], "w")
f.write(''.join('\n'.join(finalMap)))
