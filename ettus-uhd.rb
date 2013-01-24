require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class EttusUhd < Formula
  homepage ''
  head 'git://code.ettus.com/ettus/uhd.git'
  sha1 ''

  depends_on 'cmake' => :build
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
