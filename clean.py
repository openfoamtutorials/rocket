#!/usr/bin/env python

import os

folders = [x for x in os.listdir("case/") if os.path.isdir("case/" + x)]
for f in folders:
    dotsep = f.split(".")
    isfloat = len(dotsep) > 1 and all([x.isdigit() for x in dotsep])
    issci = "e-" in f
    isnum = f.isdigit() or isfloat or issci
    if isnum and float(f) != 0:
        os.system("rm -r case/" + f)
os.system("rm -f main.msh")
os.system("rm -rf case/constant/polyMesh")

