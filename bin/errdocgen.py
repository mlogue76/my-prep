#!/usr/bin/python

import sys
import os
import glob

os.system('gen_err_all.pl')

xmlfiles = glob.glob('*.xml')

for xmlfile in xmlfiles:
    os.system('iconv -f euc-kr -t utf-8 ' + xmlfile + ' > ' + xmlfile + '.tmp')
    os.system('mv ' + xmlfile + '.tmp ' + xmlfile)
