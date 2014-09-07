# homebrew-gnuradio

This is a collection of [Homebrew](https://github.com/mxcl/homebrew) recipes
that makes it easier get GNU Radio and friends running on OS X.

## Installation

These steps have been tested on Lion 10.9.4 with Xcode 5.1.

- Install the python package prerequisites

  ```sh
  brew install python gfortran umfpack swig
  ```

- Install the prerequisite python packages

  ```sh
  pip install numpy Cheetah lxml
  pip install https://github.com/scipy/scipy/tarball/v0.11.0rc2
  export PKG_CONFIG_PATH="/usr/x11/lib/pkgconfig" pip install http://downloads.sourceforge.net/project/matplotlib/matplotlib/matplotlib-1.1.1/matplotlib-1.1.1.tar.gz
  ```

- Install gnuradio (add `--with-qt` for `gr-qtgui`)

  ```sh
  brew tap ttrftech/homebrew-gnuradio
  brew install gnuradio
  ```
- Create the `~/.gnuradio/config.conf` config file for custom block support

  ```ini
  [grc]
  global_blocks_path=/usr/local/share/gnuradio/grc/blocks
  ```

### Optional (for `gr-wxgui`)

- Before installing `gnuradio`, install `wxmac` 2.9 with python bindings

  ```sh
  brew install wxmac --python
  ```

### Optional (for rtl-sdr devices)

- Install `rtlsdr` and related blocks

  ```sh
  brew install rtlsdr gr-osmosdr --HEAD
  ```

### Optional (for bladerf devices)

- Install `bladerf` and related blocks

  ```sh
  brew install bladerf gr-osmosdr --HEAD
  ```
