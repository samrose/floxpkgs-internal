rec {
  description = "virtual environments";

  inputs.capacitor.url = "git+ssh://git@github.com/flox/capacitor?ref=ysndr";
  inputs.capacitor.inputs.root.follows = "/";

  inputs.devshell.url = "github:numtide/devshell";

  outputs = _:
    _.capacitor _ ({lib, ...}:
      # numtide/devshell requires an overlay to obtain mkShell {{{
      {
        devShells.default = args:
          with (import _.devshell {
            system = args.system;
            nixpkgs = args.pkgs.unstable // {inherit lib;};
          });
          # }}}
            mkShell {
              imports = [(importTOML ./flox.toml)];
            };
      });
}
