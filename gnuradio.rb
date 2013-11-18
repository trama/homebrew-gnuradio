require 'formula'

class Gnuradio < Formula
  homepage 'http://gnuradio.org'
  url  'http://gnuradio.org/releases/gnuradio/gnuradio-3.6.3.tar.gz'
  sha1 '27c4edcc641167ba33202a7e5072e8c98891c353'
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
diff --git a/gr-qtgui/lib/spectrumdisplayform.ui b/gr-qtgui/lib/spectrumdisplayform.ui
index 049d4ff..a40502b 100644
--- a/gr-qtgui/lib/spectrumdisplayform.ui
+++ b/gr-qtgui/lib/spectrumdisplayform.ui
@@ -518,7 +518,6 @@
   </layout>
  </widget>
  <layoutdefault spacing="6" margin="11"/>
- <pixmapfunction>qPixmapFromMimeSource</pixmapfunction>
  <customwidgets>
   <customwidget>
    <class>QwtWheel</class>
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

