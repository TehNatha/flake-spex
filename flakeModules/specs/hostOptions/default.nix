lib: with lib.types; {
  typeName = "host";
  varType = attrs;
  specType = (attrsOf (either str (listOf (uniq str))));
}
