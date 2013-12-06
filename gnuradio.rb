require 'formula'

class Gnuradio < Formula
  homepage 'http://gnuradio.org'
  url  'http://gnuradio.org/releases/gnuradio/gnuradio-3.7.2.1.tar.gz'
  sha256 '8c6b7e1fda31e9228bdd62a137af901b28757d7e1b044de2e985b96e53c83c80'
  head 'git://gnuradio.org/gnuradio.git'

  depends_on 'cmake' => :build
  depends_on 'Cheetah' => :python
  depends_on 'lxml' => :python
  depends_on 'numpy' => :python
  depends_on 'scipy' => :python
  depends_on 'matplotlib' => :python
  depends_on 'python'
  depends_on 'gfortran'
  depends_on 'suite-sparse'
  depends_on 'boost'
  depends_on 'cppunit'
  depends_on 'gsl'
  depends_on 'fftw'
  depends_on 'swig'
  depends_on 'pygtk'
  depends_on 'sdl'
  depends_on 'libusb'
  depends_on 'orc'
  depends_on 'ettus-uhd'
  depends_on 'pyqt' if ARGV.include?('--with-qt')
  depends_on 'qwt' if ARGV.include?('--with-qt')
  depends_on 'pyqwt' if ARGV.include?('--with-qt')
  depends_on 'doxygen' if ARGV.include?('--with-docs')

  fails_with :clang do
    build 421
    cause "Fails to compile .S files."
  end

  def options
    [
      ['--with-qt', 'Build gr-qtgui.'],
      ['--with-docs', 'Build docs.'],
    ]
  end
  
  def patches
    DATA
  end

  def install
    mkdir 'build' do
      args = ["-DCMAKE_PREFIX_PATH=#{prefix}", "-DQWT_INCLUDE_DIRS=#{HOMEBREW_PREFIX}/lib/qwt.framework/Headers",
      "-DQWT_LIBRARIES=#{HOMEBREW_PREFIX}/lib/qwt.framework/qwt", ] + std_cmake_args
      args << '-DENABLE_GR_QTGUI=OFF' unless ARGV.include?('--with-qt')
      args << '-DENABLE_DOXYGEN=OFF' unless ARGV.include?('--with-docs')
      args << "-DPYTHON_LIBRARY=#{python_path}/Frameworks/Python.framework/"
#      args << "-Wno-c++11-narrowing" #to avoid std-c++11 narrowing errors
      system 'cmake', '..', *args
      system 'make'
      system 'make install'
    end
  end

  def python_path
    python = Formula.factory('python')
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
end

__END__
diff --git a/gr-qtgui/swig/CMakeLists.txt b/gr-qtgui/swig/CMakeLists.txt
index a1f7024..53bfe18 100644
--- a/gr-qtgui/swig/CMakeLists.txt
+++ b/gr-qtgui/swig/CMakeLists.txt
@@ -37,6 +37,8 @@ set(GR_SWIG_DOC_DIRS ${CMAKE_CURRENT_SOURCE_DIR}/../include)
 
 set(GR_SWIG_LIBRARIES gnuradio-qtgui)
 
+target_link_libraries(swig ${qtgui_libs})
+
 GR_SWIG_MAKE(qtgui_swig qtgui_swig.i)
 
 GR_SWIG_INSTALL(

diff --git a/cmake/Modules/FindQwt.cmake b/cmake/Modules/FindQwt.cmake
index d3dc7a5..3c417c7 100644
--- a/cmake/Modules/FindQwt.cmake
+++ b/cmake/Modules/FindQwt.cmake
@@ -39,7 +39,7 @@ if(QWT_INCLUDE_DIRS)
     QWT_STRING_VERSION REGEX "QWT_VERSION_STR")
   string(REGEX MATCH "[0-9]+.[0-9]+.[0-9]+" QWT_VERSION ${QWT_STRING_VERSION})
   string(COMPARE LESS ${QWT_VERSION} "5.2.0" QWT_WRONG_VERSION)
-  string(COMPARE GREATER ${QWT_VERSION} "6.0.2" QWT_WRONG_VERSION)
+  string(COMPARE GREATER ${QWT_VERSION} "6.1.2" QWT_WRONG_VERSION)
 
   message(STATUS "QWT Version: ${QWT_VERSION}")
   if(NOT QWT_WRONG_VERSION)
@@ -56,4 +56,4 @@ if(QWT_FOUND)
   include ( FindPackageHandleStandardArgs )
   find_package_handle_standard_args( Qwt DEFAULT_MSG QWT_LIBRARIES QWT_INCLUDE_DIRS )
   MARK_AS_ADVANCED(QWT_LIBRARIES QWT_INCLUDE_DIRS)
-endif(QWT_FOUND)
\ No newline at end of file
+endif(QWT_FOUND)

