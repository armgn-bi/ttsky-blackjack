Run TinyTapeout/tt-gds-action@ttsky26a
  with:
    pdk: sky130A
    tools-repo: TinyTapeout/tt-support-tools
    tools-ref: main
    librelane-version: 3.0.0
Run # Defaults:
  # Defaults:
  PDK="sky130A"
  PDK_ROOT=/home/runner/pdk
  TT_ARGS=""
  
  # Backward compatibility with old 'pdk' values
  if [ "$PDK" == "sky130" ]; then
    PDK="sky130A"
  elif [ "$PDK" == "ihp" ]; then
    PDK="ihp-sg13g2"
  fi
  
  # PDK-specific overrides
  if [ "$PDK" == "gf180mcuD" ]; then
    TT_ARGS="--gf"
  elif [ "$PDK" == "ihp-sg13g2" ]; then
    TT_ARGS="--ihp"
  fi
  
  cat << __EOF >> $GITHUB_ENV
  PDK=$PDK
  TT_ARGS=$TT_ARGS
  __EOF
  shell: /usr/bin/bash --noprofile --norc -e -o pipefail {0}
Run awalsh128/cache-apt-pkgs-action@v1.4.3
  with:
    packages: librsvg2-bin pngquant ghdl-llvm
    version: tinytapeout_gds_action
    execute_install_scripts: false
    debug: false
  env:
    PDK: sky130A
    TT_ARGS: 
Run ${GITHUB_ACTION_PATH}/pre_cache_action.sh \
  ${GITHUB_ACTION_PATH}/pre_cache_action.sh \
    ~/cache-apt-pkgs \
    "$VERSION" \
    "$EXEC_INSTALL_SCRIPTS" \
    "$DEBUG" \
    "$PACKAGES"
  echo "CACHE_KEY=$(cat ~/cache-apt-pkgs/cache_key.md5)" >> $GITHUB_ENV
  shell: /usr/bin/bash --noprofile --norc -e -o pipefail {0}
  env:
    PDK: sky130A
    TT_ARGS: 
    VERSION: tinytapeout_gds_action
    EXEC_INSTALL_SCRIPTS: false
    DEBUG: false
    PACKAGES: librsvg2-bin pngquant ghdl-llvm
19:16:13.896 Normalizing package list...
19:16:17.355 done
19:16:17.358 Validating action arguments (version='tinytapeout_gds_action', packages='ghdl-llvm=4.1.0+dfsg-0ubuntu2.1 librsvg2-bin=2.58.0+dfsg-1build1 pngquant=2.18.0-1build2')...
19:16:17.361 done

19:16:17.362 Creating cache key...
19:16:17.363 - Value to hash is 'ghdl-llvm=4.1.0+dfsg-0ubuntu2.1 librsvg2-bin=2.58.0+dfsg-1build1 pngquant=2.18.0-1build2 @ tinytapeout_gds_action 3'.
19:16:17.368 - Value hashed as '104195aae2935df101124b30c2a831f6'.
19:16:17.369 done
19:16:17.370 Hash value written to /home/runner/cache-apt-pkgs/cache_key.md5
Run actions/cache/restore@v4
Cache hit for: cache-apt-pkgs_104195aae2935df101124b30c2a831f6
Received 12482847 of 12482847 (100.0%), 78.3 MBs/sec
Cache Size: ~12 MB (12482847 B)
/usr/bin/tar -xf /home/runner/work/_temp/924ccd9f-7227-4a59-a713-aa63b763a8b5/cache.tzst -P -C /home/runner/work/ttsky-blackjack/ttsky-blackjack --use-compress-program unzstd
Cache restored successfully
Cache restored from key: cache-apt-pkgs_104195aae2935df101124b30c2a831f6
Run ${GITHUB_ACTION_PATH}/post_cache_action.sh \
19:16:17.941 Found 12 files in the cache.
19:16:17.944 - cache_key.md5
19:16:17.946 - ghdl-common=4.1.0+dfsg-0ubuntu2.1.tar
19:16:17.948 - ghdl-llvm=4.1.0+dfsg-0ubuntu2.1.tar
19:16:17.951 - install.log
19:16:17.953 - libgnat-13=13.3.0-6ubuntu2~24.04.1.tar
19:16:17.955 - libimagequant0=2.18.0-1build1.tar
19:16:17.958 - librsvg2-2=2.58.0+dfsg-1build1.tar
19:16:17.960 - librsvg2-bin=2.58.0+dfsg-1build1.tar
19:16:17.963 - librsvg2-common=2.58.0+dfsg-1build1.tar
19:16:17.965 - manifest_all.log
19:16:17.967 - manifest_main.log
19:16:17.970 - pngquant=2.18.0-1build2.tar

19:16:17.971 Reading from main requested packages manifest...
19:16:17.975 - ghdl-llvm=4.1.0+dfsg-0ubuntu2.1
19:16:17.978 - librsvg2-bin=2.58.0+dfsg-1build1
19:16:17.981 - pngquant=2.18.0-1build2
19:16:17.982 done

19:16:17.987 Restoring 8 packages from cache...
19:16:17.990 - ghdl-common=4.1.0+dfsg-0ubuntu2.1.tar restoring...
19:16:18.026   done
19:16:18.029 - ghdl-llvm=4.1.0+dfsg-0ubuntu2.1.tar restoring...
19:16:18.063   done
19:16:18.065 - libgnat-13=13.3.0-6ubuntu2~24.04.1.tar restoring...
19:16:18.086   done
19:16:18.089 - libimagequant0=2.18.0-1build1.tar restoring...
19:16:18.099   done
19:16:18.101 - librsvg2-2=2.58.0+dfsg-1build1.tar restoring...
19:16:18.118   done
19:16:18.120 - librsvg2-bin=2.58.0+dfsg-1build1.tar restoring...
19:16:18.138   done
19:16:18.140 - librsvg2-common=2.58.0+dfsg-1build1.tar restoring...
19:16:18.159   done
19:16:18.162 - pngquant=2.18.0-1build2.tar restoring...
19:16:18.172   done
19:16:18.174 done

Run rm -rf ~/cache-apt-pkgs
Run actions/checkout@v6
Syncing repository: TinyTapeout/tt-support-tools
Getting Git version info
Temporarily overriding HOME='/home/runner/work/_temp/2ebc5c87-8b43-4be1-9f32-a47cf3f41ecf' before making global git config changes
Adding repository directory to the temporary git global config as a safe directory
/usr/bin/git config --global --add safe.directory /home/runner/work/ttsky-blackjack/ttsky-blackjack/tt
Initializing the repository
Disabling automatic garbage collection
Setting up auth
Fetching the repository
Determining the checkout info
/usr/bin/git sparse-checkout disable
/usr/bin/git config --local --unset-all extensions.worktreeConfig
Checking out the ref
/usr/bin/git log -1 --format=%H
dfa73d614c6e8f7e55b860a743016d58cfe428e8
Run actions/setup-python@v6
Installed versions
/opt/hostedtoolcache/Python/3.11.15/x64/bin/pip cache dir
/home/runner/.cache/pip
Cache hit for: setup-python-Linux-x64-24.04-Ubuntu-python-3.11.15-pip-3b89daa79b462aee47b85234d7e8ae9bb90cff8e1f89806dd2b37658844c018f
Received 97528585 of 97528585 (100.0%), 179.9 MBs/sec
Cache Size: ~93 MB (97528585 B)
/usr/bin/tar -xf /home/runner/work/_temp/3a958183-581f-47ad-871d-3a8888eb745f/cache.tzst -P -C /home/runner/work/ttsky-blackjack/ttsky-blackjack --use-compress-program unzstd
Cache restored successfully
Cache restored from key: setup-python-Linux-x64-24.04-Ubuntu-python-3.11.15-pip-3b89daa79b462aee47b85234d7e8ae9bb90cff8e1f89806dd2b37658844c018f
Run pip install -r tt/requirements.txt
Collecting cairocffi==1.7.1 (from -r tt/requirements.txt (line 7))
  Using cached cairocffi-1.7.1-py3-none-any.whl.metadata (3.3 kB)
Collecting cairosvg==2.8.2 (from -r tt/requirements.txt (line 9))
  Using cached cairosvg-2.8.2-py3-none-any.whl.metadata (2.7 kB)
Collecting certifi==2025.8.3 (from -r tt/requirements.txt (line 11))
  Using cached certifi-2025.8.3-py3-none-any.whl.metadata (2.4 kB)
Collecting cffi==1.17.1 (from -r tt/requirements.txt (line 13))
  Using cached cffi-1.17.1-cp311-cp311-manylinux_2_17_x86_64.manylinux2014_x86_64.whl.metadata (1.5 kB)
Collecting cfgv==3.4.0 (from -r tt/requirements.txt (line 15))
  Using cached cfgv-3.4.0-py2.py3-none-any.whl.metadata (8.5 kB)
Collecting charset-normalizer==3.4.2 (from -r tt/requirements.txt (line 17))
  Using cached charset_normalizer-3.4.2-cp311-cp311-manylinux_2_17_x86_64.manylinux2014_x86_64.whl.metadata (35 kB)
Collecting chevron==0.14.0 (from -r tt/requirements.txt (line 19))
  Using cached chevron-0.14.0-py3-none-any.whl.metadata (4.9 kB)
Collecting click==8.2.1 (from -r tt/requirements.txt (line 21))
  Using cached click-8.2.1-py3-none-any.whl.metadata (2.5 kB)
Collecting configupdater==3.2 (from -r tt/requirements.txt (line 23))
  Using cached ConfigUpdater-3.2-py2.py3-none-any.whl.metadata (10 kB)
Collecting contourpy==1.3.3 (from -r tt/requirements.txt (line 25))
  Using cached contourpy-1.3.3-cp311-cp311-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl.metadata (5.5 kB)
Collecting cssselect2==0.8.0 (from -r tt/requirements.txt (line 27))
  Using cached cssselect2-0.8.0-py3-none-any.whl.metadata (2.9 kB)
Collecting cycler==0.12.1 (from -r tt/requirements.txt (line 29))
  Using cached cycler-0.12.1-py3-none-any.whl.metadata (3.8 kB)
Collecting defusedxml==0.7.1 (from -r tt/requirements.txt (line 31))
  Using cached defusedxml-0.7.1-py2.py3-none-any.whl.metadata (32 kB)
Collecting distlib==0.4.0 (from -r tt/requirements.txt (line 33))
  Using cached distlib-0.4.0-py2.py3-none-any.whl.metadata (5.2 kB)
Collecting filelock==3.18.0 (from -r tt/requirements.txt (line 35))
  Using cached filelock-3.18.0-py3-none-any.whl.metadata (2.9 kB)
Collecting fonttools==4.60.1 (from -r tt/requirements.txt (line 37))
  Using cached fonttools-4.60.1-cp311-cp311-manylinux2014_x86_64.manylinux_2_17_x86_64.whl.metadata (112 kB)
Collecting gdstk==0.9.60 (from -r tt/requirements.txt (line 39))
  Using cached gdstk-0.9.60-cp311-cp311-manylinux_2_28_x86_64.whl.metadata (8.8 kB)
Collecting gitdb==4.0.12 (from -r tt/requirements.txt (line 41))
  Using cached gitdb-4.0.12-py3-none-any.whl.metadata (1.2 kB)
Collecting gitpython==3.1.45 (from -r tt/requirements.txt (line 43))
  Using cached gitpython-3.1.45-py3-none-any.whl.metadata (13 kB)
Collecting identify==2.6.12 (from -r tt/requirements.txt (line 45))
  Using cached identify-2.6.12-py2.py3-none-any.whl.metadata (4.4 kB)
Collecting idna==3.10 (from -r tt/requirements.txt (line 47))
  Using cached idna-3.10-py3-none-any.whl.metadata (10 kB)
Collecting importlib-resources==6.5.2 (from -r tt/requirements.txt (line 49))
  Using cached importlib_resources-6.5.2-py3-none-any.whl.metadata (3.9 kB)
Collecting iniconfig==2.1.0 (from -r tt/requirements.txt (line 51))
  Using cached iniconfig-2.1.0-py3-none-any.whl.metadata (2.7 kB)
Collecting kiwisolver==1.4.9 (from -r tt/requirements.txt (line 53))
  Using cached kiwisolver-1.4.9-cp311-cp311-manylinux2014_x86_64.manylinux_2_17_x86_64.whl.metadata (6.3 kB)
Collecting klayout==0.29.12 (from -r tt/requirements.txt (line 55))
  Using cached klayout-0.29.12-cp311-cp311-manylinux_2_17_x86_64.manylinux2014_x86_64.whl.metadata (915 bytes)
Collecting matplotlib==3.10.6 (from -r tt/requirements.txt (line 57))
  Using cached matplotlib-3.10.6-cp311-cp311-manylinux2014_x86_64.manylinux_2_17_x86_64.whl.metadata (11 kB)
Collecting mistune==3.1.3 (from -r tt/requirements.txt (line 59))
  Using cached mistune-3.1.3-py3-none-any.whl.metadata (1.8 kB)
Collecting mpremote==1.27.0 (from -r tt/requirements.txt (line 61))
  Using cached mpremote-1.27.0-py3-none-any.whl.metadata (4.3 kB)
Collecting nodeenv==1.9.1 (from -r tt/requirements.txt (line 63))
  Using cached nodeenv-1.9.1-py2.py3-none-any.whl.metadata (21 kB)
Collecting numpy==1.26.4 (from -r tt/requirements.txt (line 65))
  Using cached numpy-1.26.4-cp311-cp311-manylinux_2_17_x86_64.manylinux2014_x86_64.whl.metadata (61 kB)
Collecting packaging==25.0 (from -r tt/requirements.txt (line 71))
  Using cached packaging-25.0-py3-none-any.whl.metadata (3.3 kB)
Collecting pillow==11.3.0 (from -r tt/requirements.txt (line 75))
  Using cached pillow-11.3.0-cp311-cp311-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl.metadata (9.0 kB)
Collecting platformdirs==4.3.8 (from -r tt/requirements.txt (line 79))
  Using cached platformdirs-4.3.8-py3-none-any.whl.metadata (12 kB)
Collecting pluggy==1.6.0 (from -r tt/requirements.txt (line 84))
  Using cached pluggy-1.6.0-py3-none-any.whl.metadata (4.8 kB)
Collecting pre-commit==4.2.0 (from -r tt/requirements.txt (line 86))
  Using cached pre_commit-4.2.0-py2.py3-none-any.whl.metadata (1.3 kB)
Collecting pycparser==2.22 (from -r tt/requirements.txt (line 88))
  Using cached pycparser-2.22-py3-none-any.whl.metadata (943 bytes)
Collecting pygments==2.19.2 (from -r tt/requirements.txt (line 90))
  Using cached pygments-2.19.2-py3-none-any.whl.metadata (2.5 kB)
Collecting pyparsing==3.2.5 (from -r tt/requirements.txt (line 92))
  Using cached pyparsing-3.2.5-py3-none-any.whl.metadata (5.0 kB)
Collecting pyserial==3.5 (from -r tt/requirements.txt (line 94))
  Using cached pyserial-3.5-py2.py3-none-any.whl.metadata (1.6 kB)
Collecting pytest==8.4.2 (from -r tt/requirements.txt (line 96))
  Using cached pytest-8.4.2-py3-none-any.whl.metadata (7.7 kB)
Collecting python-dateutil==2.9.0.post0 (from -r tt/requirements.txt (line 98))
  Using cached python_dateutil-2.9.0.post0-py2.py3-none-any.whl.metadata (8.4 kB)
Collecting python-frontmatter==1.1.0 (from -r tt/requirements.txt (line 100))
  Using cached python_frontmatter-1.1.0-py3-none-any.whl.metadata (4.1 kB)
Collecting pyyaml==6.0.2 (from -r tt/requirements.txt (line 102))
  Using cached PyYAML-6.0.2-cp311-cp311-manylinux_2_17_x86_64.manylinux2014_x86_64.whl.metadata (2.1 kB)
Collecting requests==2.32.4 (from -r tt/requirements.txt (line 107))
  Using cached requests-2.32.4-py3-none-any.whl.metadata (4.9 kB)
Collecting six==1.17.0 (from -r tt/requirements.txt (line 109))
  Using cached six-1.17.0-py2.py3-none-any.whl.metadata (1.7 kB)
Collecting smmap==5.0.2 (from -r tt/requirements.txt (line 111))
  Using cached smmap-5.0.2-py3-none-any.whl.metadata (4.3 kB)
Collecting tinycss2==1.4.0 (from -r tt/requirements.txt (line 113))
  Using cached tinycss2-1.4.0-py3-none-any.whl.metadata (3.0 kB)
Collecting urllib3==2.5.0 (from -r tt/requirements.txt (line 117))
  Using cached urllib3-2.5.0-py3-none-any.whl.metadata (6.5 kB)
Collecting virtualenv==20.33.1 (from -r tt/requirements.txt (line 119))
  Using cached virtualenv-20.33.1-py3-none-any.whl.metadata (4.5 kB)
Collecting wasmtime==35.0.0 (from -r tt/requirements.txt (line 121))
  Using cached wasmtime-35.0.0-py3-none-manylinux1_x86_64.whl.metadata (7.6 kB)
Collecting webencodings==0.5.1 (from -r tt/requirements.txt (line 123))
  Using cached webencodings-0.5.1-py2.py3-none-any.whl.metadata (2.1 kB)
Collecting yowasp-runtime==1.78 (from -r tt/requirements.txt (line 127))
  Using cached yowasp_runtime-1.78-py3-none-any.whl.metadata (2.4 kB)
Collecting yowasp-yosys==0.55.0.0.post944 (from -r tt/requirements.txt (line 129))
  Using cached yowasp_yosys-0.55.0.0.post944-py3-none-any.whl.metadata (2.6 kB)
Using cached cairocffi-1.7.1-py3-none-any.whl (75 kB)
Using cached cairosvg-2.8.2-py3-none-any.whl (45 kB)
Using cached certifi-2025.8.3-py3-none-any.whl (161 kB)
Using cached cffi-1.17.1-cp311-cp311-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (467 kB)
Using cached cfgv-3.4.0-py2.py3-none-any.whl (7.2 kB)
Using cached charset_normalizer-3.4.2-cp311-cp311-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (147 kB)
Using cached chevron-0.14.0-py3-none-any.whl (11 kB)
Using cached click-8.2.1-py3-none-any.whl (102 kB)
Using cached ConfigUpdater-3.2-py2.py3-none-any.whl (34 kB)
Using cached contourpy-1.3.3-cp311-cp311-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl (355 kB)
Using cached cssselect2-0.8.0-py3-none-any.whl (15 kB)
Using cached cycler-0.12.1-py3-none-any.whl (8.3 kB)
Using cached defusedxml-0.7.1-py2.py3-none-any.whl (25 kB)
Using cached distlib-0.4.0-py2.py3-none-any.whl (469 kB)
Using cached filelock-3.18.0-py3-none-any.whl (16 kB)
Using cached fonttools-4.60.1-cp311-cp311-manylinux2014_x86_64.manylinux_2_17_x86_64.whl (5.0 MB)
Using cached gdstk-0.9.60-cp311-cp311-manylinux_2_28_x86_64.whl (534 kB)
Using cached gitdb-4.0.12-py3-none-any.whl (62 kB)
Using cached smmap-5.0.2-py3-none-any.whl (24 kB)
Using cached gitpython-3.1.45-py3-none-any.whl (208 kB)
Using cached identify-2.6.12-py2.py3-none-any.whl (99 kB)
Using cached idna-3.10-py3-none-any.whl (70 kB)
Using cached importlib_resources-6.5.2-py3-none-any.whl (37 kB)
Using cached iniconfig-2.1.0-py3-none-any.whl (6.0 kB)
Using cached kiwisolver-1.4.9-cp311-cp311-manylinux2014_x86_64.manylinux_2_17_x86_64.whl (1.4 MB)
Using cached klayout-0.29.12-cp311-cp311-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (23.8 MB)
Using cached matplotlib-3.10.6-cp311-cp311-manylinux2014_x86_64.manylinux_2_17_x86_64.whl (8.7 MB)
Using cached mistune-3.1.3-py3-none-any.whl (53 kB)
Using cached mpremote-1.27.0-py3-none-any.whl (36 kB)
Using cached nodeenv-1.9.1-py2.py3-none-any.whl (22 kB)
Using cached numpy-1.26.4-cp311-cp311-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (18.3 MB)
Using cached packaging-25.0-py3-none-any.whl (66 kB)
Using cached pillow-11.3.0-cp311-cp311-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl (6.6 MB)
Using cached platformdirs-4.3.8-py3-none-any.whl (18 kB)
Using cached pluggy-1.6.0-py3-none-any.whl (20 kB)
Using cached pre_commit-4.2.0-py2.py3-none-any.whl (220 kB)
Using cached pycparser-2.22-py3-none-any.whl (117 kB)
Using cached pygments-2.19.2-py3-none-any.whl (1.2 MB)
Using cached pyparsing-3.2.5-py3-none-any.whl (113 kB)
Using cached pyserial-3.5-py2.py3-none-any.whl (90 kB)
Using cached pytest-8.4.2-py3-none-any.whl (365 kB)
Using cached python_dateutil-2.9.0.post0-py2.py3-none-any.whl (229 kB)
Using cached python_frontmatter-1.1.0-py3-none-any.whl (9.8 kB)
Using cached PyYAML-6.0.2-cp311-cp311-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (762 kB)
Using cached requests-2.32.4-py3-none-any.whl (64 kB)
Using cached urllib3-2.5.0-py3-none-any.whl (129 kB)
Using cached six-1.17.0-py2.py3-none-any.whl (11 kB)
Using cached tinycss2-1.4.0-py3-none-any.whl (26 kB)
Using cached virtualenv-20.33.1-py3-none-any.whl (6.1 MB)
Using cached wasmtime-35.0.0-py3-none-manylinux1_x86_64.whl (9.2 MB)
Using cached webencodings-0.5.1-py2.py3-none-any.whl (11 kB)
Using cached yowasp_runtime-1.78-py3-none-any.whl (5.2 kB)
Using cached yowasp_yosys-0.55.0.0.post944-py3-none-any.whl (9.5 MB)
Installing collected packages: webencodings, pyserial, klayout, distlib, chevron, urllib3, tinycss2, smmap, six, pyyaml, pyparsing, pygments, pycparser, pluggy, platformdirs, pillow, packaging, numpy, nodeenv, mistune, kiwisolver, iniconfig, importlib-resources, idna, identify, fonttools, filelock, defusedxml, cycler, configupdater, click, charset-normalizer, cfgv, certifi, wasmtime, virtualenv, requests, python-frontmatter, python-dateutil, pytest, mpremote, gitdb, gdstk, cssselect2, contourpy, cffi, yowasp-runtime, pre-commit, matplotlib, gitpython, cairocffi, yowasp-yosys, cairosvg

Successfully installed cairocffi-1.7.1 cairosvg-2.8.2 certifi-2025.8.3 cffi-1.17.1 cfgv-3.4.0 charset-normalizer-3.4.2 chevron-0.14.0 click-8.2.1 configupdater-3.2 contourpy-1.3.3 cssselect2-0.8.0 cycler-0.12.1 defusedxml-0.7.1 distlib-0.4.0 filelock-3.18.0 fonttools-4.60.1 gdstk-0.9.60 gitdb-4.0.12 gitpython-3.1.45 identify-2.6.12 idna-3.10 importlib-resources-6.5.2 iniconfig-2.1.0 kiwisolver-1.4.9 klayout-0.29.12 matplotlib-3.10.6 mistune-3.1.3 mpremote-1.27.0 nodeenv-1.9.1 numpy-1.26.4 packaging-25.0 pillow-11.3.0 platformdirs-4.3.8 pluggy-1.6.0 pre-commit-4.2.0 pycparser-2.22 pygments-2.19.2 pyparsing-3.2.5 pyserial-3.5 pytest-8.4.2 python-dateutil-2.9.0.post0 python-frontmatter-1.1.0 pyyaml-6.0.2 requests-2.32.4 six-1.17.0 smmap-5.0.2 tinycss2-1.4.0 urllib3-2.5.0 virtualenv-20.33.1 wasmtime-35.0.0 webencodings-0.5.1 yowasp-runtime-1.78 yowasp-yosys-0.55.0.0.post944

Notice:  A new release of pip is available: 26.0.1 -> 26.1
Notice:  To update, run: pip install --upgrade pip
Run ./tt/tt_tool.py --create-user-config $TT_ARGS
2026-04-30 19:16:47,180 - project    - ERROR    - [000 : unknown] port 'uio_oe' missing from top module ('tt_um_blackjack')
Error: Process completed with exit code 1.
Run LINTER_LOG=(runs/wokwi/*-verilator-lint/verilator-lint.log)
DEBUG LINTER_LOG *runs/wokwi/*-verilator-lint/verilator-lint.log*
cat: 'runs/wokwi/*-verilator-lint/verilator-lint.log': No such file or directory
Error: Process completed with exit code 1.
Run actions/upload-artifact@v7
Multiple search paths detected. Calculating the least common ancestor of all paths
The least common ancestor is /home/runner/work/ttsky-blackjack/ttsky-blackjack. This will be the root directory of the artifact
With the provided path, there will be 2 files uploaded
Artifact name is valid!
Root directory input is valid!
Uploading artifact: GDS_logs.zip
Beginning upload of artifact content to blob storage
Uploaded bytes 3468
Finished uploading artifact content to blob storage!
SHA256 digest of uploaded artifact is 82f5411b299aeaf7cf6655f783463f5d0cb9c476a2dddb4420dbc28cc69cd658
Finalizing artifact upload
Artifact GDS_logs successfully finalized. Artifact ID 6738266580
Artifact GDS_logs has been successfully uploaded! Final size is 3468 bytes. Artifact ID is 6738266580
Artifact download URL: https://github.com/armgn-bi/ttsky-blackjack/actions/runs/25184594191/artifacts/6738266580