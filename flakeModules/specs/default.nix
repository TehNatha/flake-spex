{ lib, flake-parts-lib,... }: let
  mkSpecificationSubmodule =
    (import ./mkSpecificationSubmodule)
      { inherit lib; };
  mkSpecGroup = options:
    lib.types.attrsOf (mkSpecificationSubmodule options);

  genericOptions = {};
  genericGroupType = mkSpecGroup genericOptions;

  hostOptions = (import ./hostOptions) lib;
  hostGroupType = mkSpecGroup hostOptions;

  serviceOptions = (import ./serviceOptions) lib;
  serviceGroupType = mkSpecGroup serviceOptions;

  userOptions = (import ./userOptions) lib;
  userGroupType = mkSpecGroup userOptions;
in {
  options = with lib; with types; {
    specs.extra = mkOption {
      type = genericGroupType;
      default = { };
      description = "A set of Specifications.";
    };
    specs.services = mkOption {
      type = serviceGroupType;
      default = { };
      description = "A set of service Specifications.";
    };
    specs.hosts = mkOption {
      type = hostGroupType;
      default = { };
      description = "A set of host Specifications.";
    };
    specs.users = mkOption {
      type = userGroupType;
      default = { };
      description = "A set of user Specifications.";
    };
  };
}
