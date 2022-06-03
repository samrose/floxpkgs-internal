rec {
  description = "Template using specific versions";

  inputs.capacitor.url = "git+ssh://git@github.com/flox/capacitor";
  inputs.capacitor.inputs.root.follows = "/";

  inputs.nixpkgs.url = "git+ssh://git@github.com/flox/nixpkgs-flox";
  inputs.nixpkgs.inputs.capacitor.follows = "capacitor";

  # inputs.floxpkgs.url = "git+ssh://git@github.com/flox/floxpkgs";
  inputs.floxpkgs.url = "/home/tom/flox/floxpkgs";
  inputs.floxpkgs.inputs.capacitor.follows = "capacitor";
  inputs.floxpkgs.inputs.nixpkgs.follows = "nixpkgs";
  inputs.floxpkgs.inputs.ops-env.follows = "/";

  # TODO: preferred method below would only need this. (https://github.com/NixOS/nix/issues/5790)
  # inputs.floxpkgs.url = "git+ssh://git@github.com/flox/floxpkgs";
  # inputs.floxpkgs.inputs.capacitor.inputs.root.follows = "/";

  nixConfig.bash-prompt = "[flox]\\e\[38;5;172mλ \\e\[m";

  outputs = _:
    _.capacitor _ ({floxpkgs, ...}: {
      devShells.default = floxpkgs.lib.mkFloxShell ./flox.toml _.self.__pins;
      apps = a:
        (floxpkgs.lib.mkUpdateVersions a)
        // (floxpkgs.lib.mkUpdateExtensions a);

      # AUTO-MANAGED AFTER THIS POINT ##################################
      # AUTO-MANAGED AFTER THIS POINT ##################################
      # AUTO-MANAGED AFTER THIS POINT ##################################
      __pins.versions = [
        (builtins.getFlake "github:NixOS/nixpkgs/4080fdcc788253bca716d559e952ccfb873ebf11").legacyPackages.x86_64-linux.kubernetes-helm
      ];
      __pins.vscode-extensions = [
        {
          name = "python";
          publisher = "ms-python";
          sha256 = "0dxlqyhcfmb0bqbny633g0hwcq5ac7nz5rrq1c795bs3pimm8p20";
          version = "2022.7.11541009";
        }
        {
          name = "pylint";
          publisher = "ms-python";
          sha256 = "0zca7w55v5xw69d7fva0mq5swc9ax36v598khzvrq3p4nzfjvfhk";
          version = "2022.1.11541003";
        }
      ];
    });
}
