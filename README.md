# homebrew-gnuradio

This is a collection of [Homebrew](https://github.com/mxcl/homebrew) recipes that makes it easier to get GNU Radio, GQRX, HackRF, RTL-SDR and BladeRF running on OS X.

## Installation

These steps have been tested on Mac OS X Yosemite 10.10 with Apple Command Line Tools 6.1.0.

- Install [Homebrew](http://brew.sh/) if you haven't already

  ```sh
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  ```
  or if you already have it installed, update and upgrade everything:
  
  ```sh
  brew update
  brew upgrade
  ```

- After that run the following commands to make sure you have no issues with your setup, cleanup all warnings

  ```sh
  brew doctor
  ```

- Add this line to your profile (ie `~/.profile` or `~/.bash_profile` or `~/.zshenv`) and reload
  your profile (`source ~/.profile` or `exec $SHELL`)

  ```sh
  export PATH=/usr/local/sbin:/usr/local/bin:$PATH
  ```

- Install the python package prerequisites

  ```sh
  brew install python gcc swig
  ```

- Install command line tools for XCode

  ```sh
  xcode-select --install
  ```

- Install the prerequisite python packages

  ```sh
  pip install numpy Cheetah lxml
  pip install https://github.com/scipy/scipy/archive/v0.12.0.tar.gz
  export PKG_CONFIG_PATH="/usr/X11/lib/pkgconfig" 
  pip install https://downloads.sourceforge.net/project/matplotlib/matplotlib/matplotlib-1.2.1/matplotlib-1.2.1.tar.gz
  ```

- Install `wxmac` with python bindings

  ```sh
  brew install wxpython
  ```

- Install gnuradio

  ```sh
  brew tap andresv/homebrew-gnuradio
  brew install gnuradio --with-qt
  ```

- [optional] install `hackrf` libraries, so `gr-osmosdr` detects it during build
  ```sh
  brew install hackrf --HEAD
  ```
  
- [optional] install `bladerf` libraries, so `gr-osmosdr` detects it during build
  ```sh
  brew install bladerf
  ```
  
- Install blocks that are needed to connect real hardware (rtl-sdr, hackrf, bladerf) to gnuradio

  ```sh
  brew install gr-osmosdr gr-baz --HEAD
  ```

- Create the `~/.gnuradio/config.conf` config file for custom block support:
  ```sh
  mkdir ~/.gnuradio
  vim ~/.gnuradio/config.conf
  ```
  Add these lines into file otherwise gnuradio is unable to locate blocks from `gr-osmosdr` and `gr-baz`:
  ```ini
  [grc]
  local_blocks_path=/usr/local/share/gnuradio/grc/blocks
  ```
  `gnuradio-companion` shows lot of duplication warnings after that - this is normal. Everything is installed correctly if `osmocom Source` and `RTL-SDR Source` blocks are available inside GNU Radio Companion.

- Install Gqrx for scanning frequencies and viewing waterfall
  
  ```sh
  brew install gqrx --HEAD
  brew linkapps
  ```
Gqrx is installed under Applications and can be started as usual Mac application.
  
Configure it to use the HackRF. Probably best to start the sample rate at 1000000 until you know how much your system can handle.
Everything should now be working. It is time to give it a try! Below are some of the programs you can try:

```sh
gnuradio-companion
osmocom_fft -a hackrf
```

##Troubleshooting

- **Matplotlib**

  If you get the following type of errors installing matplotlib:

  > error: expected identifier or '(' before '^' token
    
  Try the following:
      
  ```sh
  export CC=clang
  export CXX=clang++
  export LDFLAGS="-L/usr/X11/lib"
  export CFLAGS="-I/usr/X11/include -I/usr/X11/include/freetype2"
  ```
      
  From [Stackoverflow](http://stackoverflow.com/questions/12363557/matplotlib-install-failure-on-mac-osx-10-8-mountain-lion/15098059#15098059) via [@savant42](https://twitter.com/savant42)

- **gnuradio-companion**
  
  Probably `gr-baz.rb` is built against System's Python if gnuradio-companion crashes with the following error:

  ```sh
  Warning: Block with key "xmlrpc_server" already exists.
  Ignoring: /usr/local/Cellar/gnuradio/3.7.5.1/share/gnuradio/grc/blocks/xmlrpc_server.xml
  Fatal Python error: PyThreadState_Get: no current thread
  Abort trap: 6
  ```
  I had this error, now it is fixed with [this commit](https://github.com/andresv/homebrew-gnuradio/commit/9f738755a21efefd418c7422d99420a5f3f36998).

- **Uninstall Homebrew**
  If you think you have some cruftiness with Homebrew, this Gist will completely uninstall Homebrew and any libraries it may have installed. Of course if you are using Homebrew for other things you could make a mess of your life. 
  
  This [Gist](https://gist.github.com/mxcl/1173223) is from the [Homebrew FAQ](https://github.com/mxcl/homebrew/wiki/FAQ)
  
  Then finish the clean-up with these steps
  
  ```sh
  rm -rf /usr/local/Cellar /usr/local/.git && brew cleanup
  rm -rf /Library/Caches/Homebrew
  rm -rf /usr/local/lib/python2.7/site-packages
  ```
