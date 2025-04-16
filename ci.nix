{ config, pkgs, lib, ... }: with pkgs; with lib; let
  burrito = import ./.;
  packages = burrito.packages.${pkgs.system};
  artifactRoot = ".ci/artifacts";
  artifacts = "${artifactRoot}/";
in
{
  config = {
    name = "Burrito";
    ci.gh-actions.enable = true;
    channels = {
      nixpkgs = {
        # see https://github.com/arcnmx/nixexprs-rust/issues/10
        args.config.checkMetaRecursively = false;
        version = "22.11";
      };
    };
    tasks = {
      build.inputs = singleton packages.zip;
    };
    jobs = {
      nixos = {
        tasks = {
          build-windows.inputs = singleton packages.zip;
        };
        artifactPackages = {
          win64 = packages.zip;
        };
      };
    };

    # XXX: symlinks are not followed, see https://github.com/softprops/action-gh-release/issues/182
    artifactPackage = config.artifactPackages.win64;

    gh-actions = {
      jobs = mkIf (config.id != "ci") {
        ${config.id} = {
          permissions = {
            contents = "write";
          };
          step = {
            artifact-build = {
              order = 1100;
              name = "artifact build";
              uses = {
                # XXX: a very hacky way of getting the runner
                inherit (config.gh-actions.jobs.${config.id}.step.ci-setup.uses) owner repo version;
                path = "actions/nix/build";
              };
              "with" = {
                file = "<ci>";
                attrs = "config.jobs.${config.jobId}.artifactPackage";
                out-link = artifactRoot;
              };
            };
            artifact-upload = {
              order = 1110;
              name = "artifact upload";
              uses.path = "actions/upload-artifact@v4";
              "with" = {
                name = "TaimiHUD";
                path = artifacts;
              };
            };
            release-upload = {
              order = 1111;
              name = "release";
              "if" = "startsWith(github.ref, 'refs/tags/')";
              uses.path = "softprops/action-gh-release@v1";
              "with".files = artifacts;
            };
          };
        };
      };
    };
  };
  options = {
    artifactPackage = mkOption {
      type = types.package;
    };
    artifactPackages = mkOption {
      type = with types; attrsOf package;
    };
  };
}

