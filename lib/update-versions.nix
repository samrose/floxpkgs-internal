self: {
  pkgs,
  system,
  lib,
  self',
  root',
  ...
}: {
  update-versions = {
    type = "app";
    program = builtins.trace (builtins.attrNames root'.devShells)
      (pkgs.writeShellApplication {
        name = "update-versions";
        runtimeInputs = [self.nix-editor.packages.${system}.nixeditor pkgs.moreutils pkgs.alejandra];
        text = let
          versioned =
            builtins.filter (x: builtins.isString x && !builtins.hasContext x)
            root'.devShells.default.passthru.paths;
          split = map (x: builtins.concatStringsSep " " (lib.strings.splitString "@" x)) versioned;
        in ''
          # Reset pins
          # TODO: detect if in the correct dir
          nix-editor flake.nix "outputs.__pins.versions" -v "[]" | sponge flake.nix
          ${builtins.concatStringsSep "\n" (map (
              x: ''
                res=$(AS_FLAKEREF=1 flox run floxpkgs#find-version ${x})
                echo adding "${x} as $res"
                nix-editor flake.nix "outputs.__pins.versions" -a "(builtins.getFlake \"''${res%%\#*}\").''${res##*#}" | sponge flake.nix
              ''
            )
            split)}
          alejandra -q flake.nix
        '';
      })
      + "/bin/update-versions";
  };
}
