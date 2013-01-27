require 'formula'

class EttusUhd < Formula
  homepage 'http://www.ettus.com/'
  url 'https://github.com/EttusResearch/UHD-Mirror/archive/release_003_005_001.tar.gz'
  sha1 '29066608d36aa25d9f1dbb64e41aa81e252b638a'
  version '3.5.1'
  head 'git://github.com/EttusResearch/UHD-Mirror.git'

  depends_on 'cmake' => :build
  depends_on 'automake' => :build
  depends_on 'libusb'
  depends_on 'boost'

  def install
    cd "host"
    mkdir "build"
    cd "build"
    system "cmake","../","-DCMAKE_INSTALL_PREFIX=#{prefix}",*std_cmake_args
    # system "cmake", ".", *std_cmake_args
    system "make install" # if this fails, try separate make/make install steps
  end

  def test
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test ettus-uhd`.
    system "false"
  end
end
