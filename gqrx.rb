require 'formula'

class Gqrx < Formula
  homepage 'https://github.com/csete/gqrx'
  head 'https://github.com/csete/gqrx.git', :branch => 'master'
  url 'http://sourceforge.net/projects/gqrx/files/2.3.1/gqrx-2.3.1.tar.gz'
  sha1 '0669029987329b4cd4332e20f99b099befa44c45'

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
