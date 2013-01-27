require 'formula'

class Itpp < Formula
  homepage ''
  url 'http://sourceforge.net/projects/itpp/files/itpp/4.2.0/itpp-4.2.tar.gz'
  version '4.2'
  sha1 'be8ca932183a84be2fa387bcd6b8b2f8a66409ef'

  depends_on 'automake' => :build
  depends_on 'gnu-sed' => :build
  

  def patches
    DATA
  end

  def install
    ENV.j1
    ENV.append 'CPPFLAGS',"-fPIC"
    ENV.append 'CFLAGS',"-fPIC"
    ENV.append 'CXXFLAGS',"-fPIC"
    ENV.append 'LDFLAGS',"-lblas -llapack -framework vecLib"
    system "./autogen.sh"
    system "./configure --prefix=#{prefix}"
    system "make install" # if this fails, try separate make/make install steps
  end

  def test
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test itpp`.
    system "false"
  end
end

__END__
diff --git a/autogen.sh b/autogen.sh
index 868071e..effdf4d 100755
--- a/autogen.sh
+++ b/autogen.sh
@@ -12,8 +12,8 @@ check_tool() {
 
 check_tool "autoconf"
 check_tool "automake"
-check_tool "libtoolize"
-check_tool "sed"
+check_tool "/usr/local/bin/glibtoolize"
+check_tool "/usr/local/bin/gsed"
 
 test "$DIE" = yes && exit 1
 
diff --git a/autogen.sh b/autogen.sh
index effdf4d..7356b64 100755
--- a/autogen.sh
+++ b/autogen.sh
@@ -13,7 +13,7 @@ check_tool() {
 check_tool "autoconf"
 check_tool "automake"
 check_tool "/usr/local/bin/glibtoolize"
-check_tool "/usr/local/bin/gsed"
+check_tool "gsed"
 
 test "$DIE" = yes && exit 1
 
@@ -51,7 +51,7 @@ sed -e "s/@PACKAGE_VERSION@/${PV}/" -e "s/@PACKAGE_DATE@/${PD}/" \
 test ! -d build-aux && (mkdir build-aux || exit $?)
 
 aclocal -I m4 || exit $?
-libtoolize --copy --force --automake || exit $?
+/usr/local/bin/glibtoolize --copy --force --automake || exit $?
 aclocal -I m4 || exit $?
 autoconf || exit $?
 autoheader || exit $?
diff --git a/configure.ac.in b/configure.ac.in
index efd55e6..3338ea6 100644
--- a/configure.ac.in
+++ b/configure.ac.in
@@ -25,7 +25,7 @@ AC_CONFIG_HEADER([itpp/config.h])
 AC_CONFIG_SRCDIR([itpp/base/vec.cpp])
 AC_CONFIG_MACRO_DIR([m4])
 AC_CONFIG_AUX_DIR([build-aux])
-AM_INIT_AUTOMAKE([-Wall -Werror])
+AM_INIT_AUTOMAKE([-Wall -Werror -Wno-extra-portability])
 
 # Shared library versioning
 GENERIC_LIBRARY_VERSION="@LIBRARY_VERSION@"
