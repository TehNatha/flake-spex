lib: with lib.types; {
  typeName = "service";
  varType = attrs;
  specType = (attrsOf (either str (listOf (uniq str))));
}
