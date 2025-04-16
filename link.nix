{ lib
, fetchFromGitHub
, stdenv
, unzip
, alsa-lib
, gcc-unwrapped
, git
, cmake
, src
, version
}:

stdenv.mkDerivation rec {
  pname = "burrito_link";
  inherit src version;

  sourceRoot = "source/burrito_link";

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    stdenv.cc
  ];

  installPhase = let
    localName = builtins.replaceStrings ["-"] ["_"] pname;
  in ''
    mkdir -p $out/{lib,bin}
    mv *.dll $out/lib
    mv ${localName}.exe.exe $out/bin/${localName}.exe
  '';

  meta = with lib; {
    homepage = "https://github.com/AsherGlick/Burrito";
    description = "An overlay tool for Guild Wars 2 that works on linux";
    license = licenses.gpl2;
    #platforms   = platforms.linux;
    maintainers = [ ];
  };
}

