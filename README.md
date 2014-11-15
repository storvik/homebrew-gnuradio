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

- Install the prerequisite python packages

  ```sh
  pip install numpy Cheetah lxml
  pip install https://github.com/scipy/scipy/archive/v0.12.0.tar.gz
  export PKG_CONFIG_PATH="/usr/X11/lib/pkgconfig" 
  pip install https://downloads.sourceforge.net/project/matplotlib/matplotlib/matplotlib-1.2.1/matplotlib-1.2.1.tar.gz
  ```

- Install `wxmac` 2.9 with python bindings

  ```sh
  brew install wxmac --python
  ```

- Install gnuradio

  ```sh
  brew tap andresv/homebrew-gnuradio
  brew install gnuradio --with-qt
  ```

- Create the `~/.gnuradio/config.conf` config file for custom block support and add this into it

  ```ini
  [grc]
  local_blocks_path=/usr/local/share/gnuradio/grc/blocks
  ```

- Install blocks that are needed to connect real hardware to gnuradio

  ```sh
  brew install gr-osmosdr gr-baz --HEAD
  ```

### Optional (for hackrf devices)

- Install `hackrf`

  ```sh
  brew install hackrf --HEAD
  ```

### Optional (for bladerf devices)

- Install `bladerf`

  ```sh
  brew install bladerf
  ```

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
  
  If gnuradio-companion crashes with following error (it happened with older 3.6.5.1 gnuradio), there must be something wrong with Python. Probably some of the libraries are still using system Python.

  ```sh
  Warning: Block with key "xmlrpc_server" already exists.
  Ignoring: /usr/local/Cellar/gnuradio/3.6.5.1/share/gnuradio/grc/blocks/xmlrpc_server.xml
  Fatal Python error: PyThreadState_Get: no current thread
  Abort trap: 6
  ```

  To test this theory rename system python to something else and reinstall boost:

  ```sh
  sudo mv /System/Library/Frameworks/Python.framework/ /System/Library/Frameworks/Backup.Python.framework
  brew reinstall boost
  ```

  I got it to work in this way. I have not renamed system Python back to original, however I guess it could be done after this step.

- **Uninstall Homebrew**
  If you think you have some cruftiness with Homebrew, this Gist will completely uninstall Homebrew and any libraries it may have installed. Of course if you are using Homebrew for other things you could make a mess of your life. 
  
  This [Gist](https://gist.github.com/mxcl/1173223) is from the [Homebrew FAQ](https://github.com/mxcl/homebrew/wiki/FAQ)
  
  Then finish the clean-up with these steps
  
  ```sh
  rm -rf /usr/local/Cellar /usr/local/.git && brew cleanup
  rm -rf /Library/Caches/Homebrew
  rm -rf /usr/local/lib/python2.7/site-packages
  ```
