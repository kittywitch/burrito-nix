{ lib
, fetchFromGitHub
, stdenv
, unzip
, alsa-lib
, gcc-unwrapped
, git
, protobuf
, godot3-mono-export-templates
, godot3-mono-headless
, libGLU
, libX11
, libXcursor
, libXext
, libXfixes
, libXi
, libXinerama
, libXrandr
, libXrender
, udev
, libglvnd
, libpulseaudio
, zlib
, src
, version
, taco_parser
, burrito-fg
}:

stdenv.mkDerivation {
  pname = "burrito";
  inherit src version;

  nativeBuildInputs = [
    godot3-mono-headless
    unzip
  ];

  buildInputs = [
    protobuf
    alsa-lib
    gcc-unwrapped.lib
    git
    libGLU
    libX11
    libXcursor
    libXext
    libXfixes
    libXi
    libXinerama
    libXrandr
    libXrender
    libglvnd
    libpulseaudio
    zlib
    taco_parser
    burrito-fg
  ];

  propagatedBuildInputs = [
    udev
  ];

  buildPhase =
    let
      libExt = stdenv.hostPlatform.extensions.sharedLibrary;
    in
    ''
      runHook preBuild

      export HOME=$TMPDIR
      mkdir -p $HOME/.local/share/godot
      ln -s ${godot3-mono-export-templates}/share/godot/templates $HOME/.local/share/godot
      mkdir -p burrito-fg/target/release/
      cp -r ${burrito-fg}/lib/libburrito_fg${libExt} burrito-fg/target/release/
      mkdir -p taco_parser/target/release/
      cp -r ${taco_parser}/lib/libgw2_taco_parser${libExt} taco_parser/target/release/

      # https://github.com/AsherGlick/Burrito/blob/master/.github/workflows/main.yml#L214

      mkdir -p $out/bin/
      godot3-mono-headless --export "Linux/X11" $out/bin/burrito.x86-64

      runHook postBuild
    '';

  dontInstall = true;
  dontFixup = true;
  dontStrip = true;

  meta = with lib; {
    homepage = "https://github.com/AsherGlick/Burrito";
    description = "An overlay tool for Guild Wars 2 that works on linux";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ ];
    mainProgram = "burrito.x86_64";
  };
}

