{ lib, ... }:
let

  attrToTags = with builtins; name: value:
    if (isString value)
      then [ "${name}-${value}" ]
    else if (isList value)
      then map (item: "${name}-${item}") value
    else [ "${name}" ];

  specToTags = with lib; spec:
    concatMap
      (name: attrToTags name spec.${name})
      (attrNames spec);

  specGenericTypeModule = with lib; with types;
    { config, ... }: {
      options = {
        name = mkOption {
          type = str;
          default = name;
          description = "Name of the specification.";
        };
        vars = mkOption {
          type = attrsOf anything;
          default = { };
          description = "Variable values for the specification.";
        };
        spec = mkOption {
          type = attrsOf (either str (listOf (uniq str)));
          default = { };
          description = "Specification values.";
        };
      };
    };

  specBaseType = with lib; with types;
    { config, ... }: {
      options = {
        extraTags = mkOption {
          type = listOf (uniq str);
          default = [ ];
          description = "Extra tags for user or admin use.";
        };
        tags = mkOption {
          type = listOf (uniq str);
          default = specToTags config.spec ++ config.extraTags;
          readOnly = true;
          description = "Computed tags for the specification. This value is automatically computed from `spec` and `extraTags`.";
        };
      };
    };

  hostTypeModule = with lib; with types;
    { config, name, ... }: {
      name = mkOption {
        type = str;
        default = name;
        description = "Name of the host.";
      };

      vars = {
        machineId = mkOption {
          type = str;
          default = "";
          description = "ID for host as given in /etc/machine-id";
        };
      };

      spec = {
        platform = mkOption {
          type = enum [
            "darwin"
            "linux"
            "none"
          ];
          description = "Software platform for host.";
        };
        system = mkOption {
          type = str;
          default = with config; "${arch}-${platform}";
          description = "Sorftware and hardware system for the host";
        };
        arch = mkOption {
          type = enum [
            "x86_64"
            "aarch64"
            "none"
          ];
          description = "Machine architecture for host.";
        };
      };
    };
in
{
  options = with lib; with types; {
    specs = mkOption {
      type = attrsOf (submoduleWith);
      default = { };
      description = "A sets of Specifications.";
    };
    _specsInternal.typeRegistry = mkOption {
      type = attrs;
      default = {};
    };
  };

  config._specsInternal.typeRegistry
}
