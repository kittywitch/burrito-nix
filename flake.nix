{
  description = "Burrito";
  inputs = {
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = (import nixpkgs) {
          inherit system;
        };

        pkgsCross = (import nixpkgs) {
          inherit system;
          crossSystem.config = "x86_64-w64-mingw32";
        };

        src = pkgs.fetchFromGitHub {
          owner = "AsherGlick";
          repo = "Burrito";
          rev = "3c974aadd50959bc8fde99cb1b96e5d017454b6b";
          hash = "sha256-GjSkpi8SZL7uCUKzOmEbAPOc/5TjAnFJO0//MAoARo0=";
        };

        version = "20240616";
        arguments = {
          inherit src version;
        };

        packages = rec {
          xml_converter = pkgs.callPackage ./xml_converter.nix arguments;
          taco_parser = pkgs.callPackage ./taco_parser.nix arguments;
          burrito-fg = pkgs.callPackage ./burrito-fg.nix arguments;
          burrito_godot = pkgs.callPackage ./godot.nix (arguments // { inherit taco_parser burrito-fg; });
          burrito_link = pkgsCross.callPackage ./link.nix arguments;
          burrito = pkgs.symlinkJoin {
            name = "burrito";
            paths = [
              burrito-fg
              taco_parser
              burrito_godot
              xml_converter
              burrito_link
            ];
            meta.mainProgram = "burrito.x86-64";
          };
        };
      in {
        inherit packages;
      });
}

