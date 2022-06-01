self: _: toml: lock: pins: {pkgs, ...}: let
  data =
    self.lib.flox-env {
      inherit (_) mach-nix;
      floxpkgs-lib = self.lib;
      capacitor-lib = _.capacitor.lib;
      lib = _.capacitor.inputs.nixpkgs-lib.lib;
    }
    pkgs
    toml
    lock;
in
  self.lib.mkNakedShell {
    inherit (_) devshell;
    inherit data;
    inherit pkgs;
    inherit pins;
    floxpkgs = self;
    lib = self.lib;
  }
