rec {
  description = "Template using specific versions";

  inputs.capacitor.url = "git+ssh://git@github.com/flox/capacitor";
  inputs.capacitor.inputs.root.follows = "/";

  inputs.nixpkgs.url = "git+ssh://git@github.com/flox/nixpkgs-flox";
  inputs.nixpkgs.inputs.capacitor.follows = "capacitor";

  inputs.floxpkgs.url = "git+ssh://git@github.com/flox/floxpkgs";
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
      apps = floxpkgs.apps;

      # AUTO-MANAGED AFTER THIS POINT ##################################
      # AUTO-MANAGED AFTER THIS POINT ##################################
      # AUTO-MANAGED AFTER THIS POINT ##################################
      __pins.versions = [
        (builtins.getFlake "github:NixOS/nixpkgs/43cc623340ac0723fb73c1bce244bb6d791c5bb9").legacyPackages.x86_64-linux.curl
      ];
      __pins.vscode-extensions = [
        {
          name = "python";
          publisher = "ms-python";
          sha256 = "1pfmvg93z3i6rmqfb4dkgswkjj1y8px36jwfkdpkzykrzdhv0l9b";
          version = "2022.7.11591004";
        }
        {
          name = "pylint";
          publisher = "ms-python";
          sha256 = "1z9qng63wqyb2namxlvw5wjrhc6v7y8gg4ipwrb3dqs50f8n0nnj";
          version = "2022.1.11581003";
        }
      ];
    });
}
