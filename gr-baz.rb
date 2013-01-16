require 'formula'

class GrBaz < Formula
  homepage 'http://wiki.spench.net/wiki/Gr-baz'
  head 'https://github.com/balint256/gr-baz.git', :revision => '0392ebece4'

  depends_on 'pkg-config' => :build
  depends_on 'automake' => :build
  depends_on 'libtool' => :build
  depends_on 'libusb'
  depends_on 'gnuradio'

  def patches
	  DATA
  end

  def install
    args = ["--prefix=#{prefix}"]
    system "autoreconf -i"
    system "./configure", *args
    system "make"
    system "make install"
  end
end
__END__
diff --git a/config/usrp_libusb.m4 b/config/usrp_libusb.m4
index cb3130c..c860318 100644
--- a/config/usrp_libusb.m4
+++ b/config/usrp_libusb.m4
@@ -19,7 +19,7 @@ dnl Boston, MA 02110-1301, USA.
 
 AC_DEFUN([USRP_LIBUSB], [
     libusbok=yes
-    PKG_CHECK_MODULES(USB, libusb, [], [
+    PKG_CHECK_MODULES(USB, libusb-1.0, [], [
         AC_LANG_PUSH(C)
 
        AC_CHECK_HEADERS([usb.h], [], [libusbok=no; AC_MSG_RESULT([USRP requires libusb. usb.h not found. See http://libusb.sf.net])])

