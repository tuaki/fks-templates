#!/usr/bin/env python
import sys
import re
import os
import unicodedata
import shutil
from tempfile import NamedTemporaryFile

if len(sys.argv) < 3:
    print("Usage: {} wikisrc destdir\n".format(sys.argv[0]))
    sys.exit(1)

task = re.compile('.*\probname(\[cs\])?{.*}.*')
begin = re.compile('^\s*<file latex')
end = re.compile('^\s*</file>')
cnt = 0
inside = False

sort = open("{}/problem-sort.tex".format(sys.argv[2]), "w")

for line in open(sys.argv[1]):
    if begin.match(line):
        cnt += 1
        out = NamedTemporaryFile(mode="w", delete=False)
        inside = True
        continue
    if task.match(line):
        lineASCI = unicodedata.normalize('NFKD', line.decode("UTF-8")).encode('ascii','ignore').replace (" ", "-").lower()
        tasksearch = re.search('probname(?:\[cs\])?{-*(.*)-*}',lineASCI)
        taskname = tasksearch.group(1)
        taskname = re.sub('[^a-zA-Z0-9_-]', '', taskname)
        if not taskname:
            taskname = cnt
        print(taskname)
        sort.write("\\addproblem{{{}}}{{}}\n".format(taskname))
    if end.match(line):
        inside = False
        tmp = out.name
        out.close()
        shutil.copy(tmp, "{}/problem_{}.tex".format(sys.argv[2], taskname))
        os.remove(tmp)
    if inside:
        out.write(line)

sort.close()

print("\nParsed {} tasks.".format(cnt))
