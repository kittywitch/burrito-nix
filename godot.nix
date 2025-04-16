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
, libglvnd
, libpulseaudio
, zlib
, src
, version
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
  ];

  buildPhase = ''
    runHook preBuild

    export HOME=$TMPDIR
    mkdir -p $HOME/.local/share/godot
    ln -s ${godot3-mono-export-templates}/share/godot/templates $HOME/.local/share/godot

    # https://github.com/AsherGlick/Burrito/blob/master/.github/workflows/main.yml#L214
    mkdir -p burrito-fg/target/release/
    touch burrito-fg/target/release/libburrito_fg.so
    mkdir -p taco_parser/target/release/
    touch taco_parser/target/release/libgw2_taco_parser.so

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
    platforms   = platforms.linux;
    maintainers = [ ];
    mainProgram = "burrito.x86-64";
  };
}

