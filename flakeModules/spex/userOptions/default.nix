lib: with lib.types; {
  typeName = "users";
  varType = attrs;
  specType = (attrsOf (either str (listOf (uniq str))));
}
