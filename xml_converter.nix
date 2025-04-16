{ lib
, fetchFromGitHub
, stdenv
, unzip
, alsa-lib
, gcc-unwrapped
, git
, cmake
, protobuf
, protobufc
, gtest
, src
, version
}:

stdenv.mkDerivation rec {
  pname = "xml_converter";
  inherit src version;
  sourceRoot = "source/xml_converter";

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    protobuf
    protobufc
  ];

  cmakeFlags = let
    inherit (lib) cmakeFeature getInclude getLib;
    libExt = stdenv.hostPlatform.extensions.sharedLibrary;
  in [
    (cmakeFeature "Protobuf_LIBRARIES" "${getLib protobuf}/lib/libprotobuf${libExt}")
    (cmakeFeature "GTEST_MAIN_LIBRARY" "${getLib gtest}/lib/libgtest_main${libExt}")
    (cmakeFeature "GTEST_LIBRARY" "${getLib gtest}/lib/libgtest${libExt}")
    (cmakeFeature "GTEST_INCLUDE_DIR" "${getInclude gtest}/include")
  ];

  installPhase = ''
    mkdir -p $out/bin
    mv xml_converter $out/bin
  '';

  meta = with lib; {
    homepage = "https://github.com/AsherGlick/Burrito";
    description = "An overlay tool for Guild Wars 2 that works on linux";
    license = licenses.gpl2;
    #platforms   = platforms.linux;
    maintainers = [ ];
  };
}

