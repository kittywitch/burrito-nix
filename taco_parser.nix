{ lib, rustPlatform, src, version, clang }:

rustPlatform.buildRustPackage rec {
  pname = "taco_parser";
  inherit version src;
  sourceRoot = "source/taco_parser";

  patchFlags = ["-p2"];
  patches = [
    ./gdnative-tacoparser.patch
  ];

  cargoLock.lockFile = ./tacoparser-cargo.lock;
  cargoHash = lib.fakeHash;

  buildInputs = [
    clang
    rustPlatform.bindgenHook
  ];

  meta = {
    homepage = "https://github.com/AsherGlick/Burrito";
    description = "An overlay tool for Guild Wars 2 that works on linux";
    license = lib.licenses.gpl2;
    platforms   = lib.platforms.linux;
    maintainers = [ ];
  };
}
