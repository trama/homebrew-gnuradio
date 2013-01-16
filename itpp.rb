require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Itpp < Formula
  homepage ''
  url 'http://sourceforge.net/projects/itpp/files/itpp/4.2.0/itpp-4.2.tar.bz2/download'
  version '4.2'
  sha1 '3b75fbcbbc43ac6e47d80283ffd41673ccfa035e'

  # depends_on 'cmake' => :build
  depends_on :x11 # if your formula requires any X11/XQuartz components

  def install
    # ENV.j1  # if your formula's build system can't parallelize

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    # system "cmake", ".", *std_cmake_args
    system "make install" # if this fails, try separate make/make install steps
  end

  def test
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test itpp`.
    system "false"
  end
end
