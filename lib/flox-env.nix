{
  mach-nix,
  lib,
}: pkgs: toml: pins: let
  tie = {
    inherit pkgs;
    mach = mach-nix.lib.${pkgs.system};
    vscodeLib = lib.vscode;
  };
  data = (lib.custom {}).processTOML toml {
    pkgs = tie.pkgs;
    floxEnv = {programs, ...}: let
      paths = let
        handler = {
          python = mach-nix.lib.${pkgs.system}.mkPython programs.python;
          vscode =
            lib.vscode.configuredVscode
            pkgs
            programs.vscode
            pins.vscode-extensions;

          # insert excpetions here
          __functor = self: key: attr:
            self.${key}
            or (
              if attr ? version
              then "${key}@${attr.version}"
              else pkgs.${key}
            );
        };
      in
        lib.mapAttrsToList handler programs;
    in
      (pkgs.buildEnv {
        name = "flox-env";
        inherit paths;
      })
      // {passthru.paths = paths;};
  };
in
  data
