require 'formula'

class Bladerf < Formula
  homepage 'http://sdr.osmocom.org/trac/wiki/rtl-sdr'
  head 'https://github.com/Nuand/bladeRF.git'

  depends_on 'pkg-config' => :build
  depends_on 'automake' => :build
  depends_on 'libtool' => :build
  depends_on 'cmake' => :build
  depends_on 'libusb'

  def install
    mkdir 'build' do
      system 'cmake', '..', *std_cmake_args
      system 'make'
      system 'make install'
    end
  end
end
