require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Gqrx < Formula
  homepage 'https://github.com/csete/gqrx'
  head 'https://github.com/csete/gqrx.git'

  depends_on 'cmake' => :build
  depends_on 'qt'
#brew install --with-c+11 --universal boost
  depends_on 'boost'
  depends_on 'gnuradio'

  def patches
    #patch to compile to binary, comment out pulse audio and link boost correctly
    DATA
  end

  def install
    system "qmake gqrx.pro"
    system "make"
    bin.install 'gqrx.app/Contents/MacOS/gqrx'
  end
end
__END__
diff --git a/gqrx.pro b/gqrx.pro
index a7ac741..423dbc2 100644
--- a/gqrx.pro
+++ b/gqrx.pro
@@ -6,17 +6,11 @@
 
 QT       += core gui svg
 TEMPLATE = app
-
-macx {
-    TARGET = Gqrx
-    ICON = icons/scope.icns
-} else {
-    TARGET = gqrx
-}
+TARGET = gqrx
 
 linux-g++|linux-g++-64 {
     # Comment out to use gnuradio-audio (wont work on Linux)
-    AUDIO_BACKEND = pulse
+    # AUDIO_BACKEND = pulse
 }
 
 RESOURCES += icons.qrc
@@ -159,7 +153,7 @@ unix:!macx {
 #    LIBS += -lrt  # need to include on some distros
 }
 
-macx-g++ {
+macx {
      LIBS += -lboost_system-mt -lboost_program_options-mt
 #    INCLUDEPATH += /usr/local/include
 #    INCLUDEPATH += /usr/local/include/gnuradio

