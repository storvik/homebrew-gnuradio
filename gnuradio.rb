require 'formula'

class Gnuradio < Formula
  homepage 'http://gnuradio.org'
  url  'http://gnuradio.org/releases/gnuradio/gnuradio-3.7.5.tar.gz'
  sha1 'fe30be815aca149bfac1615028a279aea40c3bbb'
  head 'http://gnuradio.org/git/gnuradio.git'

  depends_on 'cmake' => :build
  depends_on 'Cheetah' => :python
  depends_on 'lxml' => :python
  depends_on 'numpy' => :python
  depends_on 'scipy' => :python
  depends_on 'matplotlib' => :python
  depends_on 'python'
  depends_on 'boost'
  depends_on 'gsl'
  depends_on 'fftw'
  depends_on 'swig' => :build
  depends_on 'pygtk'
  depends_on 'sdl'

  depends_on 'libusb'
  depends_on 'orc'
  depends_on 'pyqt' if build.with? 'qt'
  depends_on 'pyqwt' if build.with? 'qt'
  depends_on 'doxygen' if build.with? 'docs'

  option 'with-qt', 'Build with Qt 4 or 5 support'
  option 'with-docs', 'Build programming documentation(in API documentation) and html man page'

  fails_with :clang do
    build 421
    cause "Fails to compile .S files."
  end

  def patches
    DATA
  end

  def install

    mkdir 'build' do
      args = ["-DCMAKE_PREFIX_PATH=#{prefix}", "-DQWT_INCLUDE_DIRS=#{HOMEBREW_PREFIX}/lib/qwt.framework/Headers"] + std_cmake_args
      args << '-DENABLE_GR_QTGUI=OFF' if build.without? 'qt'
      args << '-DENABLE_DOXYGEN=OFF' if build.without? 'docs'
      args << '-DCMAKE_CXX_FLAGS=-std=c++11 -stdlib=libc++ -Wno-narrowing -Wno-static-float-init'
      args << '-DCMAKE_CXX_LINK_FLAGS=-stdlib=libc++'

      # From opencv.rb
      python_prefix = `python-config --prefix`.strip
      # Python is actually a library. The libpythonX.Y.dylib points to this lib, too.
      if File.exist? "#{python_prefix}/Python"
        # Python was compiled with --framework:
        args << "-DPYTHON_LIBRARY='#{python_prefix}/Python'"
        if !MacOS::CLT.installed? and python_prefix.start_with? '/System/Library'
          # For Xcode-only systems, the headers of system's python are inside of Xcode
          args << "-DPYTHON_INCLUDE_DIR='#{MacOS.sdk_path}/System/Library/Frameworks/Python.framework/Versions/2.7/Headers'"
        else
          args << "-DPYTHON_INCLUDE_DIR='#{python_prefix}/Headers'"
        end
      else
        python_lib = "#{python_prefix}/lib/lib#{which_python}"
        if File.exists? "#{python_lib}.a"
          args << "-DPYTHON_LIBRARY='#{python_lib}.a'"
        else
          args << "-DPYTHON_LIBRARY='#{python_lib}.dylib'"
        end
        args << "-DPYTHON_INCLUDE_DIR='#{python_prefix}/include/#{which_python}'"
      end
      args << "-DPYTHON_PACKAGES_PATH='#{lib}/#{which_python}/site-packages'"

      system 'cmake', '..', *args
      system 'make'
      system 'make install'
    end
  end

  def python_path
    python = Formula['python']
    kegs = python.rack.children.reject { |p| p.basename.to_s == '.DS_Store' }
    kegs.find { |p| Keg.new(p).linked? } || kegs.last
  end

  def caveats
    <<-EOS.undent
    If you want to use custom blocks, create this file:

    ~/.gnuradio/config.conf
      [grc]
      local_blocks_path=/usr/local/share/gnuradio/grc/blocks
    EOS
  end

  def which_python
    "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
  end
end

__END__
diff --git a/gr-fec/lib/cc_decoder_impl.cc b/gr-fec/lib/cc_decoder_impl.cc
index 20587a2..f0d8cfd 100644
--- a/gr-fec/lib/cc_decoder_impl.cc
+++ b/gr-fec/lib/cc_decoder_impl.cc
@@ -147,8 +147,11 @@ namespace gr {
           d_SUBSHIFT = 0;
         }
 
+#if defined(__GXX_EXPERIMENTAL_CXX0X__) || __cplusplus >= 201103L
+        yp_kernel = {{"k=7r=2", volk_8u_x4_conv_k7_r2_8u}};
+#else
         yp_kernel = boost::assign::map_list_of("k=7r=2", volk_8u_x4_conv_k7_r2_8u);
-
+#endif
         std::string k_ = "k=";
         std::string r_ = "r=";
