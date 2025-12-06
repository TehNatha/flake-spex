specLib: { flake-parts-lib, ... }: let
  inherit (flake-parts-lib) importApply;
in {
  imports = [
    (import ./lib)
    (importApply ./options specLib)
  ];
}
