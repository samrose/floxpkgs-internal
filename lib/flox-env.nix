pkgs: lock: programs:
let
  libVscode = (import ./vscode.nix);
  configurePrograms = programName: programConfig:
    if programName == "vscode" then
      libVscode.configuredVscode pkgs programConfig lock.vscode
    else
      pkgs.${programName};
in pkgs.buildEnv {
  name = "flox-shell";
  paths = pkgs.lib.attrsets.mapAttrsToList configurePrograms programs.programs;
}
