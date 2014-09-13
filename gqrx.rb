require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
# from: https://github.com/xlfe/homebrew-gnuradio

class Gqrx < Formula
  homepage 'https://github.com/csete/gqrx'
  head 'https://github.com/csete/gqrx.git', :branch => 'master'

  depends_on 'cmake' => :build
  depends_on 'pkg-config' => :build
  depends_on 'qt'
  depends_on 'boost'
  depends_on 'gnuradio'
  depends_on 'gr-osmosdr'

  def install
    args = "PREFIX=#{prefix}" 
    mkdir "build" do
      system "qmake",  *args, ".."
      system "make"
    end
    Dir.glob("build/*.app") { |app| mv app, prefix }
  end
end