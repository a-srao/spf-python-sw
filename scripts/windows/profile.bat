echo off
python -m cProfile -o profile.pstats /../../src/hello_world.py
gprof2dot -f pstats profile.pstats | ${graphviz}\\bin\\dot -Tpng -o out1.png