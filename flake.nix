{
  description = "Specification Options for Hosts, Networks, and Services";

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { ... }:
      let
        specModule = import ./specs;
      in
      {
        systems = [
          "x86_64-linux"
          "x86_64-darwin"
          "aarch64-linux"
          "aarch64-darwin"
        ];
        imports = [ specModule ];
        flake = {
          flakeModule = specModule;
          flakeModules.default = specModule;
        };
      }
    );

  inputs.flake-parts.url = "github:hercules-ci/flake-parts";
}
