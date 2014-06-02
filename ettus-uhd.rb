require 'formula'

class EttusUhd < Formula
  homepage 'http://www.ettus.com/'
  url 'https://github.com/EttusResearch/uhd/archive/release_003_007_001.zip'
  sha1 '3c5fa141e2f00ed9683e15195904facf1d02de62'
  version '3.7.1'
  head 'git://github.com/EttusResearch/UHD.git'

  depends_on 'cmake' => :build
  depends_on 'automake' => :build
  depends_on 'libusb'
  depends_on 'boost'

  #def patches
  #  DATA
  #end
  
  def install
    ENV.prepend_create_path 'PYTHONPATH', libexec+'lib/python2.7/site-packages'
    install_args = [ "setup.py", "install", "--prefix=#{libexec}" ]
    #cd "host"
    mkdir "build"
    cd "build"
    system "cmake","../","-DCMAKE_INSTALL_PREFIX=#{prefix}",*std_cmake_args
    # system "cmake", ".", *std_cmake_args
    system "make"
    system "make install" # if this fails, try separate make/make install steps
  end
  
  def test
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test ettus-uhd`.
    system "false"
  end
end

__END__
# diff --git a/host/lib/usrp/dboard_id.cpp b/host/lib/usrp/dboard_id.cpp
# index 3028d2a..24d1f95 100644
# --- a/host/lib/usrp/dboard_id.cpp
# +++ b/host/lib/usrp/dboard_id.cpp
# @@ -51,7 +51,10 @@ template <class T> struct to_hex{
#  
#  dboard_id_t dboard_id_t::from_string(const std::string &string){
#      if (string.substr(0, 2) == "0x"){
# -        return dboard_id_t::from_uint16(boost::lexical_cast<to_hex<boost::uint16_t> >(string));
# +	std::stringstream interpreter(string);
# +        to_hex<boost::uint16_t> hh;
# +        interpreter >> hh;
# +        return dboard_id_t::from_uint16(hh);
#      }
#      return dboard_id_t::from_uint16(boost::lexical_cast<boost::uint16_t>(string));
#  }
# diff --git a/host/utils/b2xx_fx3_utils.cpp b/host/utils/b2xx_fx3_utils.cpp
# index c182548..6c5a35d 100644
# --- a/host/utils/b2xx_fx3_utils.cpp
# +++ b/host/utils/b2xx_fx3_utils.cpp
# @@ -58,7 +58,10 @@ template <class T> struct to_hex{
#  //!parse hex-formatted ASCII text into an int
#  boost::uint16_t atoh(const std::string &string){
#      if (string.substr(0, 2) == "0x"){
# -        return boost::lexical_cast<to_hex<boost::uint16_t> >(string);
# +    	std::stringstream interpreter(string);
# +        to_hex<boost::uint16_t> hh;
# +        interpreter >> hh;
# +        return hh.value;
#      }
#      return boost::lexical_cast<boost::uint16_t>(string);
#  }
# 
# 
# 
