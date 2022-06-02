{
  mach-nix,
  lib,
}: pkgs: toml: lock: let
  tie = {
    inherit pkgs;
    mach = mach-nix.lib.${pkgs.system};
    vscodeLib = lib.vscode;
  };
  data = (lib.custom {}).processTOML toml {
    pkgs = tie.pkgs;
    floxEnv = {
      name,
      programs,
      ...
    }: let
      paths = let
        attrs = builtins.removeAttrs programs ["postShellHook" "python" "vscode"];
        handler = {
          python = mach-nix.lib.${pkgs.system}.mkPython programs.python;
          vscode =
            lib.vscode.configuredVscode
            pkgs
            programs.vscode
            (builtins.fromJSON (builtins.readFile lock)).vscode;
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
      (pkgs.buildEnv {inherit name paths;}) // {passthru.paths = paths;};
  };
in
  data
