#!/bin/sh

# Quit script if any step has error:
set -e

# Make the mesh:
gmsh mesh/main.geo -o main.msh -format msh2 -3
# Convert the mesh to OpenFOAM format:
gmshToFoam main.msh -case case
# Adjust polyMesh/boundary:
changeDictionary -case case
# Finally, run the simulation:
sonicFoam -case case

