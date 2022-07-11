{self, root, inputs}: toml: pins: {pkgs, ...}: let
  data =
    self.lib.flox-env {
      inherit (inputs) mach-nix;
    }
    pkgs
    toml
    pins;
in
  self.lib.mkNakedShell {
    inherit (inputs) devshell;
    inherit data;
    inherit pkgs;
    inherit pins;
    floxpkgs = self;
    lib = root.lib;
  }
