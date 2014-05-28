require 'formula'

class Gnuradio < Formula
  homepage 'http://gnuradio.org'
  url  'http://gnuradio.org/releases/gnuradio/gnuradio-3.7.3.tar.gz'
  sha256 '1c71d1819a67bac4148c619fc2a7d2c0ea0b0d08aa4660a11d65ab7b713b5231'
  head 'git://gnuradio.org/gnuradio.git'

  depends_on 'cmake' => :build
  depends_on 'Cheetah' => :python
  depends_on 'lxml' => :python
  depends_on 'numpy' => :python
  depends_on 'scipy' => :python
  depends_on 'matplotlib' => :python
  depends_on 'python'
  depends_on 'boost'
  depends_on 'fftw'
  depends_on 'gsl'
  # depends_on 'ice'
  depends_on 'orc'
  depends_on 'pygtk'
  depends_on 'sdl'
  depends_on 'swig'
  depends_on 'wxpython'
  # depends_on 'gfortran'
  # depends_on 'suite-sparse'
  # depends_on 'cppunit'
  # depends_on 'libusb'
  depends_on 'ettus-uhd'
  depends_on 'pyqt' if ARGV.include?('--with-qt')
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
    ENV.prepend_create_path 'PYTHONPATH', libexec+'lib/python2.7/site-packages'
    install_args = [ "setup.py", "install", "--prefix=#{libexec}" ]
    
    mkdir 'build' do
      args = ["-DCMAKE_PREFIX_PATH=#{prefix}", "-DQWT_INCLUDE_DIRS=#{HOMEBREW_PREFIX}/lib/qwt.framework/Headers", "-DQWT_LIBRARIES=#{HOMEBREW_PREFIX}/lib/qwt.framework/qwt", ] + std_cmake_args
      #args = std_cmake_args
      args << '-DENABLE_GR_QTGUI=OFF' unless ARGV.include?('--with-qt')
      args << '-DENABLE_DOXYGEN=OFF' unless ARGV.include?('--with-docs')
      
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
      
      # args << "-Wno-c++11-narrowing" #to avoid std-c++11 narrowing errors

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
# diff --git a/gr-qtgui/swig/CMakeLists.txt b/gr-qtgui/swig/CMakeLists.txt
# index a1f7024..53bfe18 100644
# --- a/gr-qtgui/swig/CMakeLists.txt
# +++ b/gr-qtgui/swig/CMakeLists.txt
# @@ -37,6 +37,8 @@ set(GR_SWIG_DOC_DIRS ${CMAKE_CURRENT_SOURCE_DIR}/../include)
#  
#  set(GR_SWIG_LIBRARIES gnuradio-qtgui)
#  
# +target_link_libraries(swig ${qtgui_libs})
# +
#  GR_SWIG_MAKE(qtgui_swig qtgui_swig.i)
#  
#  GR_SWIG_INSTALL(

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

