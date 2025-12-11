{ lib }: with lib; with types; {
    typeName ? "specification",
    varType ? attrs,
    specType ? (attrsOf (either str (listOf (uniq str))))
}: let
  attrToTags = with builtins; name: value:
    if (isString value)
      then [ "${name}-${value}" ]
    else if (isList value)
      then map (item: "${name}-${item}") value
    else [ "${name}" ];
  specToTags = with lib; spec: concatMap
    (name: attrToTags name spec.${name})
    (attrNames spec);
in submodule ({ config, name, ... }: {
  options = {
    name = mkOption {
      type = str;
      default = name;
      description = "Name of the ${typeName}.";
    };
    vars = mkOption {
      type = varType;
      default = { };
      description = "Variable values for the ${typeName}.";
    };
    spec = mkOption {
      type = specType;
      default = { };
      description = "Specification values for the ${typeName}.";
    };
    extraTags = mkOption {
      type = listOf (uniq str);
      default = [ ];
      description = "Extra tags for user or admin use.";
    };
    tags = mkOption {
      type = listOf (uniq str);
      default = specToTags config.spec ++ config.spec.extraTag;
      readOnly = true;
      description = "Computed tags for the specification. This value is automatically computed from `spec` and `extraTags`.";
    };
  };
})
