{
  description = "Specification Options for Hosts, Networks, and Services";

  outputs =
    inputs@{ self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { flake-parts-lib, ... }: let
        inherit (flake-parts-lib) importApply;

        spexModule.imports = [
          ./flakeModules/spex
          ./flakeModules/spex-builders-colmenaHive
        ];
      in
      {
        systems = [
          "x86_64-linux"
          "x86_64-darwin"
          "aarch64-linux"
          "aarch64-darwin"
        ];
        imports = [ spexModule ];
        flake = {
          flakeModule = spexModule;
          flakeModules.default = spexModule;
        };
      }
    );

    inputs.flake-parts.url = "github:hercules-ci/flake-parts";
}
