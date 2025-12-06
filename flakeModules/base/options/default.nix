specLib:
{ lib, ... }: {
  options = with lib; with types; with specLib; {
    specs.extra = mkOption {
      type = specLib.types.groups.generic;
      default = { };
      description = "A set of Specifications.";
    };
    specs.services = mkOption {
      type = specLib.types.groups.generic;
      default = { };
      description = "A set of service Specifications.";
    };
    specs.users = mkOption {
      type = specLib.types.groups.generic;
      default = { };
      description = "A set of user Specifications.";
    };
    specs.hosts = mkOption {
      type = specLib.types.groups.generic;
      default = { };
      description = "A set of host Specifications.";
    };
  };
}
