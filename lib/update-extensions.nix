self: {
  pkgs,
  system,
  lib,
  self',
  root',
  ...
}: {
  update-extensions = {
    type = "app";
    program =
      (pkgs.writeShellApplication {
        name = "update-extensions";
        runtimeInputs = [self.nix-editor.packages.${system}.nixeditor pkgs.moreutils pkgs.alejandra];
        text = let
          extensions = root'.devShells.default.passthru.data.attrs.programs.vscode.extensions;
          split = map (x: builtins.concatStringsSep "." (lib.strings.splitString "." x)) extensions;
          libVscode = (import ../lib/vscode.nix);
        in ''
          wd="$1"
          cd "$wd"
          raw_extensions=$(flox eval .#devShells.x86_64-linux.default.passthru.data.attrs.programs --json | jq '
            .vscode.extensions|
            select(.!=null)|
            .[]
          ' -cr)
          res=$({
          echo "'''"
          # shellcheck disable=SC2086
          ${../apps/generate_extensions.sh} $raw_extensions | jq -s
          echo "'''"
          } | flox eval --file - --apply builtins.fromJSON)
          # Reset pins
          # TODO: detect if in the correct dir
          echo "storing:"
          echo "$res"
          if [ ! -v DRY_RUN ]; then
            nix-editor flake.nix "outputs.__pins.vscode-extensions" -v "$res" | sponge flake.nix
            alejandra -q flake.nix
          else
            echo "dry run" >&2
          fi
        '';
      })
      + "/bin/update-extensions";
  };
}
