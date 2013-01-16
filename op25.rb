require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Op25 < Formula
  homepage 'http://op25.osmocom.org'
  head 'http://op25.osmocom.org/svn/trunk', :using => :svn
  sha1 ''

  env :userpaths

  fails_with :clang do
  end

  # depends_on 'cmake' => :build
  depends_on :x11 # if your formula requires any X11/XQuartz components
  def patches
	DATA
  end


  def install
    # ENV.j1  # if your formula's build system can't parallelize
	  #
    cd "blocks"
    system "./bootstrap"

    system "./configure", "--prefix=#{prefix}"
    # system "cmake", ".", *std_cmake_args
    system "make"
    system "make install" # if this fails, try separate make/make install steps
  end

  def test
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test op25`.
    system "false"
  end
end
__END__
diff --git a/blocks/bootstrap b/blocks/bootstrap
index dabd4d2..ccb323c 100755
--- a/blocks/bootstrap
+++ b/blocks/bootstrap
@@ -25,5 +25,5 @@ rm -fr config.cache autom4te*.cache
 aclocal -I config
 autoconf
 autoheader
-libtoolize --automake
+glibtoolize --automake
 automake --add-missing -c -f
diff --git a/blocks/Makefile.common b/blocks/Makefile.common
index f9c7f21..126b54b 100644
--- a/blocks/Makefile.common
+++ b/blocks/Makefile.common
@@ -38,7 +38,7 @@ grpyexecdir = $(pyexecdir)/gnuradio
 
 # swig flags
 SWIGPYTHONFLAGS = -fvirtual -python -modern
-SWIGGRFLAGS = -I$(GNURADIO_CORE_INCLUDEDIR)/swig -I$(gruelincludedir)/swig -I$(GNURADIO_CORE_INCLUDEDIR)
+SWIGGRFLAGS = -I$(GNURADIO_CORE_INCLUDEDIR)/swig -I$(GNURADIO_CORE_INCLUDEDIR)/../gruel/swig -I$(GNURADIO_CORE_INCLUDEDIR)
 
 # Don't assume that make predefines $(RM), because BSD make does
 # not. We define it now in configure.ac using AM_PATH_PROG, but now
diff --git a/blocks/config/lf_warnings.m4 b/blocks/config/lf_warnings.m4
index 4e2ca91..8bc2c2c 100644
--- a/blocks/config/lf_warnings.m4
+++ b/blocks/config/lf_warnings.m4
@@ -112,7 +112,7 @@ AC_DEFUN([LF_SET_WARNINGS],[
   AC_MSG_RESULT($lf_warnings)
   
   dnl Warnings for the two main compilers
-  cc_warning_flags="-Wall"
+  cc_warning_flags="-Wall -ferror-limit=0"
   cxx_warning_flags="-Wall -Woverloaded-virtual"
   if test $lf_warnings = yes
   then

