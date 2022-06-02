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
          nix-editor .flox/flake.nix "outputs.__pins" -v "[]" | sponge .flox/flake.nix
          ${builtins.concatStringsSep "\n" (map (
              x: ''
                res=$(AS_FLAKEREF=1 flox run floxpkgs#find-version ${x})
                echo adding "${x} as $res"
                nix-editor .flox/flake.nix "outputs.__pins" -a "(builtins.getFlake \"''${res%%\#*}\").''${res##*#}" | sponge .flox/flake.nix
                alejandra -q .flox/flake.nix
              ''
            )
            split)}
        '';
      })
      + "/bin/update-versions";
  };
}
