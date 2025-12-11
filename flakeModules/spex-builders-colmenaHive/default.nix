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

  deployment = spec: {
    targetHost = "${spec.name}.${spec.spec.network}";
    targetPort = 22;
    targetUser = "colmena";
    tags = spec.tags;

    keys.machine-id =
      mkIf (with spec; hasAttr "machineId" vars && vars.machineId != null) {
        destDir = "/etc";
        permissions = "0444";
        text = spec.vars.machineId;
      };
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
