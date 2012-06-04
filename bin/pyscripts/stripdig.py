#!/bin/env python

"""
stripdig.py
Purpose: stripping didgits in front of file names.
Created: 2012-05-16
Maintainer: Filip Pettersson
Email: filip.diloom@gmail.com
"""
import re
import os

geting = re.compile('(^\d+-|^\d+\S\d+-)')

for filename in  os.listdir('.'):
    if re.match('\d', filename) is None:
        continue
    nameparts = re.split(geting, filename)
    nr_parts = len(nameparts)
    if nr_parts != 3:
        print nameparts
        continue
    else:
        newname = nameparts[2]
    os.rename(filename, newname)

