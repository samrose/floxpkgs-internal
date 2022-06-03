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
          # System should not matter here
          raw_versions=$(flox eval .#devShells.x86_64-linux.default.passthru.data.attrs --json | jq '
            .programs|
            to_entries|
            map(select(.value|has("version")))|
            .[]|
            [.key,.value.version]|@tsv
          ' -cr)
          if [ ! -v DRY_RUN ]; then
            nix-editor flake.nix "outputs.__pins.versions" -v "[]" | sponge flake.nix
          else
            echo "dry run" >&2
          fi
          # TODO: do resolution in parallel
          while read -r line; do
              # shellcheck disable=SC2086
              res=$(AS_FLAKEREF=1 flox run floxpkgs#find-version $line)
              echo "adding $line as $res to $PWD/flake.nix"
              # shellcheck disable=SC2086
              if [ ! -v DRY_RUN ]; then
                nix-editor flake.nix "outputs.__pins.versions" -a "(builtins.getFlake \"''${res%%\#*}\").''${res##*#}" | sponge flake.nix
              fi
          done < <(echo "$raw_versions")
          alejandra -q flake.nix
        '';
      })
      + "/bin/update-versions";
  };
}
