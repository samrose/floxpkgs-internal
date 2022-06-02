rec {
  description = "Template using specific versions";

  inputs.capacitor.url = "git+ssh://git@github.com/flox/capacitor";
  inputs.capacitor.inputs.root.follows = "/";

  inputs.nixpkgs.url = "git+ssh://git@github.com/flox/nixpkgs-flox";
  inputs.nixpkgs.inputs.capacitor.follows = "capacitor";

  #inputs.floxpkgs.url = "git+ssh://git@github.com/flox/floxpkgs";
  inputs.floxpkgs.url = "/home/tom/flox/floxpkgs";
  inputs.floxpkgs.inputs.capacitor.follows = "capacitor";
  inputs.floxpkgs.inputs.nixpkgs.follows = "nixpkgs";
  inputs.floxpkgs.inputs.ops-env.follows = "/";

  # TODO: preferred method below would only need this. (https://github.com/NixOS/nix/issues/5790)
  # inputs.floxpkgs.url = "git+ssh://git@github.com/flox/floxpkgs";
  # inputs.floxpkgs.inputs.capacitor.inputs.root.follows = "/";

  nixConfig.bash-prompt = "[flox]\\e\[38;5;172mλ \\e\[m";

  outputs = _:
    _.capacitor _ ({
      self,
      floxpkgs,
      ...
    }: {
      devShells.default = floxpkgs.lib.mkFloxShell ./flox.toml _.self.pins;
      apps = a:
        (floxpkgs.lib.mkUpdateVersions a)
        // (floxpkgs.lib.mkUpdateExtensions a);

      # AUTO-MANAGED
      pins = builtins.mapAttrs (_: v:
        builtins.listToAttrs (map (x: {
            name = builtins.replaceStrings ["."] ["_"] x.name;
            value = x;
          })
          v))
      _.self.__pins;
      __pins.versions = [
        (builtins.getFlake "github:NixOS/nixpkgs/4080fdcc788253bca716d559e952ccfb873ebf11").legacyPackages.x86_64-linux.kubernetes-helm
      ];
      __pins.vscode-extensions = [
        {
          name = "pylint";
          publisher = "ms-python";
          sha256 = "1xivywac0kdh78kdjwhhlbji77296pfvkyc5wdv763c08xzb5gnb";
          version = "2022.1.11521003";
        }
      ];
      # AUTO-MANAGED
    });
}
