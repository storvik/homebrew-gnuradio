require "formula"

class Libfec < Formula
  homepage "http://www.ka9q.net/code/fec/"
  url "http://www.ka9q.net/code/fec/fec-3.0.1.tar.bz2"
  sha1 "d5cac0680b055c7808e3b33876ab4e819cd318ae"

  patch :p1 do
    url "http://lodge.glasgownet.com/bitsnbobs/kg_fec-3.0.1.patch"
    sha1 "fc25babccb5ce3e783619f886c858b28f42652b9"
  end

  def install
    system "./configure", "--target=x86_64-apple-darwin13.3.0",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end
end
