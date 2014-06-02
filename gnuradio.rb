require 'formula'

class Gnuradio < Formula
  homepage 'http://gnuradio.org'
  url  'http://gnuradio.org/releases/gnuradio/gnuradio-3.7.3.tar.gz'
  sha256 '1c71d1819a67bac4148c619fc2a7d2c0ea0b0d08aa4660a11d65ab7b713b5231'
  head 'git://gnuradio.org/gnuradio.git'

  depends_on 'cmake' => :build
  depends_on 'scipy' => :python
  depends_on 'boost'
  depends_on 'fftw'
  depends_on 'pygtk'
  depends_on 'swig'
  depends_on 'wxpython'
  depends_on 'cppunit'
  depends_on 'pyqt' if ARGV.include?('--with-qt')
  depends_on 'pyqwt' if ARGV.include?('--with-qt')
  depends_on 'doxygen' if ARGV.include?('--with-docs')
  # depends_on 'gfortran'
  # depends_on 'suite-sparse'
  # depends_on 'libusb'
  # depends_on 'sdl'
  # depends_on 'Cheetah' => :python
  # depends_on 'lxml' => :python
  # depends_on 'numpy' => :python
  # depends_on 'matplotlib' => :python
  # depends_on 'python'
  # depends_on 'gsl'
  # depends_on 'ice'
  # depends_on 'orc'
  # depends_on 'ettus-uhd'
  
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
  
  def which_python
    "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
  end
  
end

__END__
