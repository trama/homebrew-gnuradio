# homebrew-gnuradio

This is a collection of [Homebrew](https://github.com/mxcl/homebrew) recipes
that makes it easier get GNU Radio and friends running on OS X.

## Note - Warning

[These formula](https://github.com/trama/homebrew-gnuradio) are a work in progress and so not yet stable.
I have just forked them to test on a fresh Mavericks install!
And I am trying to update to the last gnu radio 3.7 series...
Hope this will work :)

## Tested on

I am testing under the following environment:

HOMEBREW_VERSION: 0.9.5
ORIGIN: https://github.com/mxcl/homebrew
HEAD: aee75f1898c0628523e41fdd665abadc647209d7
HOMEBREW_PREFIX: /usr/local
HOMEBREW_CELLAR: /usr/local/Cellar
CPU: 8-core 64-bit haswell
OS X: 10.9-x86_64
CLT: 5.0.1.0.1.1382131676
Clang: 5.0 build 500
X11: 2.7.5 => /opt/X11
System Ruby: 1.8.7-358
Perl: /usr/bin/perl
Python: /usr/bin/python
Ruby: /usr/bin/ruby => /System/Library/Frameworks/Ruby.framework/Versions/2.0/usr/bin/rub

Updates in the following days!

## Installation

- Add this line to your profile (ie `~/.bash_profile` or `~/.zshenv`) and reload
  your shell (`exec $SHELL`)

  ```sh
  export PATH=/usr/local/bin:/usr/local/share/python:$PATH
  ```

- Install python and other important dependencies

  ```sh
  brew install python gfortran swig
  ```
  Package umfpack is now in suite-sparse, so see the following commands...

- Tap samueljohn/homebrew-python for scipy (and numpy)

  ```sh
  brew tap samueljohn/homebrew-python
  brew tap homebrew/science
  brew install numpy scipy pixman
  brew install matplotlib --with-gtk --with-wx --with-pyqt 
  ```
  If you have also installed python3, in my case I had also to install pip-2.7, nose and pyparsing.
  ```sh
  sudo easy_install-2.7 pip
  sudo pip-2.7 install nose
  sudo pip-2.7 install pyparsing
  ```
- Install the prerequisite python packages

  ```sh
  sudo pip-2.7 install numpy Cheetah lxml
  ```

- Tap trama/homebrew-gnuradio

  ```sh
  brew tap trama/homebrew-gnuradio
  ```

- Before installing `gnuradio`, install `wxmac` 2.9 with python bindings

  ```sh
  brew install wxmac --python
  ```

- Install gnuradio (`--with-qt`)

  ```sh
  brew install --with-qt gnuradio
  ```
- Create the `~/.gnuradio/config.conf` config file for custom block support

  ```ini
  [grc]
  local_blocks_path=/usr/local/share/gnuradio/grc/blocks
  ```

- Install `rtlsdr` `gr-baz` and optionally `op25` and `gqrx`

  ```sh
  brew install --HEAD rtlsdr gr-osmosdr gr-baz 
  brew install --HEAD op25 gqrx
  ```
