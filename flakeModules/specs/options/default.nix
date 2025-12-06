specLib:
{ lib, ... }: {
  options = with lib; with types; with specLib; {
    specs.extra = mkOption {
      type = attrsOf (mkSpecSubmodule {});
      default = { };
      description = "A set of Specifications.";
    };
    specs.services = mkOption {
      type = attrsOf (mkSpecSubmodule {});
      default = { };
      description = "A set of service Specifications.";
    };
    specs.users = mkOption {
      type = attrsOf (mkSpecSubmodule {});
      default = { };
      description = "A set of user Specifications.";
    };
    specs.hosts = mkOption {
      type = attrsOf (mkSpecSubmodule {});
      default = { };
      description = "A set of host Specifications.";
    };
  };
}
