{ lib, rustPlatform, src, version, clang }:

rustPlatform.buildRustPackage rec {
  pname = "burrito-fg";
  inherit version src;
  sourceRoot = "source/burrito-fg";

  patchFlags = ["-p2"];
  patches = [
    ./gdnative-burritofg.patch
  ];

  cargoLock.lockFile = ./burrito-fg-cargo.lock;
  cargoHash = lib.fakeHash;

  buildInputs = [
    clang
    rustPlatform.bindgenHook
  ];

  doCheck = false;

  meta = {
    homepage = "https://github.com/AsherGlick/Burrito";
    description = "An overlay tool for Guild Wars 2 that works on linux";
    license = lib.licenses.gpl2;
    platforms   = lib.platforms.linux;
    maintainers = [ ];
  };
}
