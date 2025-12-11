{
  self,
  config,
  lib,
  inputs,
  ...
}:
with lib;
with builtins;
let
  hosts = config.spex.hosts;

  forEachHost = builder: (mapAttrs builder hosts);
  forModuleIn = hostSpec: (moduleName: _: elem moduleName (hostSpec.spec.modules ++ [hostSpec.name]) );

  filterModulesForHostSpec =
    modules: hostSpec: filterAttrs (forModuleIn hostSpec) modules;

  mkKeys = { hostSpec, keys?{ machine-id = "/etc"; } }:
    mapAttrs
    (key: dir:
      mkIf (with hostSpec; hasAttr key vars && vars.${key} != null) {
        destDir = dir;
        permissions = "0444";
        text = spec.vars.${key};
      }
    )
    keys;

  mkDeployment = hostSpec: {
    targetHost = "${hostSpec.name}.${hostSpec.spec.network}";
    targetPort = 22;
    targetUser = "colmena";
    tags = hostSpec.tags;
    keys = mkKeys { inherit hostSpec; };
  };
in
{
  flake = {
    colmenaHive = inputs.colmena.lib.makeHive self.outputs.colmena;

    colmena = {
      meta = {
        specialArgs = { inherit inputs; };
        nodeSpecialArgs = forEachHost (
          name: spec: {
            inherit name spec;
          }
        );

        nixpkgs = import inputs.nixpkgs { system = "x86_64-linux"; };
        nodeNixpkgs =
          with inputs;
          forEachHost (_: hostSpec: with hostSpec.spec; import nixpkgs { inherit system; });
      };
    }
    // forEachHost (
      _: hostSpec: with inputs; {
        imports = [ secrets.nixosModules.secrets ]
        ++ map (module: self.nixosModules.${module}) hostSpec.spec.modules
        ++ [({ deployment = mkDeployment hostSpec; })];
      }
    );
  };
}
