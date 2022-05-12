echo off
python -m cProfile -o profile.pstats D://slave/workspace/ting_feature_Unit-Perf-TestTools/src/hello_world.py
gprof2dot -f pstats profile.pstats | ${graphviz}\\bin\\dot -Tpng -o out1.png