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

  specGroupType = with lib; with types;
    attrsOf (submodule ({ config, name, ... }: {
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
        extraTags = mkOption {
          type = listOf (uniq str);
          default = [ ];
          description = "Extra tags for user or admin use.";
        };
        tags = mkOption {
          type = listOf (uniq str);
          default = specToTags config.spec;
          readOnly = true;
          description = "Computed tags for the specification. This value is automatically computed from `spec` and `extraTags`.";
        };
      };
    }));
in
{
  options.specs = with lib; with types; mkOption {
    type = attrsOf specGroupType;
    default = { };
    description = "A sets of Specifications.";
  };
}
