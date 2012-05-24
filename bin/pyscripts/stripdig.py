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

geting = re.compile('[a-z]/S+')

for filename in  os.listdir('.'):
    if re.match(geting, filename, flags=re.IGNORECASE) != None:
        continue
    newname = re.split(geting, filename, flags=re.IGNORECASE)

