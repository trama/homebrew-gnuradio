# homebrew-gnuradio

This is a collection of [Homebrew](https://github.com/mxcl/homebrew) recipes
that makes it easier get GNU Radio and friends running on OS X.

## Note - Warning

[These formula](https://github.com/xlfe/homebrew-gnuradio) are a work in progress and so ymmv...

## Tested on

These steps have been tested under the following environment:

	```HOMEBREW_VERSION: 0.9.3
	ORIGIN: https://github.com/mxcl/homebrew
	HEAD: f8e58e1153680e3a03839b726b50c8ec7d176649
	HOMEBREW_PREFIX: /usr/local
	HOMEBREW_CELLAR: /usr/local/Cellar
	CPU: quad-core 64-bit ivybridge
	OS X: 10.8.2-x86_64
	Xcode: 4.5.2
	CLT: 4.5.0.0.1.1249367152
	GCC-4.2: build 5666
	LLVM-GCC: build 2336
	Clang: 4.1 build 421
	X11: 2.7.4 => /opt/X11
	System Ruby: 1.8.7-358
	Perl: /usr/bin/perl
	Python: /usr/bin/python
	Ruby: /usr/bin/ruby => /System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/bin/ruby
	```
## Installation

- Add this line to your profile (ie `~/.bash_profile` or `~/.zshenv`) and reload
  your shell (`exec $SHELL`)

  ```sh
  export PATH=/usr/local/bin:/usr/local/share/python:$PATH
  ```

- Install python and other important eependencies

  ```sh
  brew install python gfortran umfpack swig
  ```

- Tap samueljohn/homebrew-python for scipy (and numpy)

  ```sh
  brew tap samueljohn/homebrew-python
  brew install numpy scipy pixman
  brew install matplotlib --with-gtk --with-wx --with-pyqt 
  ```

- Install the prerequisite python packages

  ```sh
  pip install numpy Cheetah lxml
  ```

- Install older version of automake (otherwise ettus-uhd won't build) and ettus-uhd

  ```sh
  brew tap xlfe/homebrew-gnuradio
  brew install xlfe/gnuradio/automake
  brew install --HEAD --use-gcc ettus-uhd 
  ```

- Before installing `gnuradio`, install `wxmac` 2.9 with python bindings

  ```sh
  brew install wxmac --python
  ```

- Link in the qwt and Qt framekworks
  ```sh
  ln -s /usr/local/lib/qwt* /usr/local/Cellar/python/2.7.3/Frameworks/
  ln -s /usr/local/lib/Qt* /usr/local/Cellar/python/2.7.3/Frameworks/
  ```

- Install gnuradio (add `--with-qt` for `gr-qtgui`)

  ```sh
  brew install --with-qt --use-gcc gnuradio
  ```
- Create the `~/.gnuradio/config.conf` config file for custom block support

  ```ini
  [grc]
  local_blocks_path=/usr/local/share/gnuradio/grc/blocks
  ```

- Install `rtlsdr` and related blocks

  ```sh
  brew install rtlsdr gr-osmosdr gr-baz --HEAD
  ```

- Install `op25` and `gqrx`

  ```sh
  brew install --HEAD --use-gcc op25 gqrx
  ```
