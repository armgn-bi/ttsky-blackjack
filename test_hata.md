  cd test
  make clean
  make
  # make will return success even if the test fails, so check for failure in the results.xml
  ! grep failure results.xml
  shell: /usr/bin/bash -e {0}
  env:
    pythonLocation: /opt/hostedtoolcache/Python/3.11.15/x64
    PKG_CONFIG_PATH: /opt/hostedtoolcache/Python/3.11.15/x64/lib/pkgconfig
    Python_ROOT_DIR: /opt/hostedtoolcache/Python/3.11.15/x64
    Python2_ROOT_DIR: /opt/hostedtoolcache/Python/3.11.15/x64
    Python3_ROOT_DIR: /opt/hostedtoolcache/Python/3.11.15/x64
    LD_LIBRARY_PATH: /opt/hostedtoolcache/Python/3.11.15/x64/lib
rm -f results.xml
"make" -f Makefile results.xml
make[1]: Entering directory '/home/runner/work/ttsky-blackjack/ttsky-blackjack/test'
mkdir -p sim_build/rtl
/usr/bin/iverilog -o sim_build/rtl/sim.vvp -s tb -g2012 -I/home/runner/work/ttsky-blackjack/ttsky-blackjack/test/../src -f sim_build/rtl/cmds.f  /home/runner/work/ttsky-blackjack/ttsky-blackjack/test/../src/project.v /home/runner/work/ttsky-blackjack/ttsky-blackjack/test/tb.v
/home/runner/work/ttsky-blackjack/ttsky-blackjack/test/../src/project.v:59: error: 'state' has already been declared in this scope.
/home/runner/work/ttsky-blackjack/ttsky-blackjack/test/../src/project.v:48:      : It was declared here as a net.
make[1]: *** [/opt/hostedtoolcache/Python/3.11.15/x64/lib/python3.11/site-packages/cocotb_tools/makefiles/simulators/Makefile.icarus:52: sim_build/rtl/sim.vvp] Error 1
make[1]: Leaving directory '/home/runner/work/ttsky-blackjack/ttsky-blackjack/test'
make: *** [/opt/hostedtoolcache/Python/3.11.15/x64/lib/python3.11/site-packages/cocotb_tools/makefiles/Makefile.inc:17: sim] Error 2
Error: Process completed with exit code 2.