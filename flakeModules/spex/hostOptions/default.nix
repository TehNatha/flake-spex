lib: with lib; with types; {
  typeName = "host";
  varType = submodule {
    options = {
      machineId = mkOption {
        type = str;
        default = "";
        description = "ID for host as given in /etc/machine-id";
      };
    };
  };
  specType = submodule ({ config, ...}: {
    options = {
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
      deploy = mkOption {
        type = enum [
          "colmena"
          "reference"
        ];
        default = "reference";
        description = "Style of deployment for host.";
      };
      network = mkOption {
        type = enum [
          "lan"
          "none"
        ];
        default = "lan";
        description = "Host network (as a TLD)";
      };
      modules = mkOption {
        type = listOf str;
        default = [];
        description = "Host modules";
      };
    };
  });
}
