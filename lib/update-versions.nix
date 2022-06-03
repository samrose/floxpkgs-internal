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
    program =
      (pkgs.writeShellApplication {
        name = "update-versions";
        runtimeInputs = [self.nix-editor.packages.${system}.nixeditor pkgs.moreutils pkgs.alejandra];
        text = let
          versioned =
            builtins.filter (x: builtins.isString x && !builtins.hasContext x)
            # self-inspection of the paths we are interested in
            root'.devShells.default.passthru.paths;
          split = map (x: builtins.concatStringsSep " " (lib.strings.splitString "@" x)) versioned;
        in ''
          wd="$1"
          cd "$wd"
          # Reset pins
          # TODO: detect if in the correct dir
          if [ ! -v DRY_RUN ]; then
            nix-editor flake.nix "outputs.__pins.versions" -v "[]" | sponge flake.nix
          else
            echo "dry run" >&2
          fi
          ${builtins.concatStringsSep "\n" (map (
              x: ''
                res=$(AS_FLAKEREF=1 flox run floxpkgs#find-version ${x})
                echo adding "${x} as $res"
                # shellcheck disable=SC2086
                if [ ! -v DRY_RUN ]; then
                  nix-editor flake.nix "outputs.__pins.versions" -a "(builtins.getFlake \"''${res%%\#*}\").''${res##*#}" | sponge flake.nix
                fi
              ''
            )
            split)}
          alejandra -q flake.nix
        '';
      })
      + "/bin/update-versions";
  };
}
