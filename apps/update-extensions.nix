{
  nix-editor,
  moreutils,
  alejandra,
  writeShellApplication,
  ...
}: {
    type = "app";
    program =
      (writeShellApplication {
        name = "update-extensions";
        runtimeInputs = [nix-editor moreutils alejandra];
        text = ''
          wd="$1"
          cd "$wd"
          if [ -v DEBUG ]; then set -x; fi
          raw_extensions=$(flox eval .#devShells.x86_64-linux.default.passthru.data.attrs.programs --json | jq '
            .vscode.extensions|
            select(.!=null)|
            .[]
          ' -cr)
          if [ -z "$raw_extensions" ]; then
            echo no extensions >&2
            exit 0
          fi

          res=$({
          echo "'''"
          # shellcheck disable=SC2086
          ${./generate_extensions.sh} $raw_extensions | jq -s
          echo "'''"
          } | flox eval --file - --apply builtins.fromJSON)
          # Reset pins
          # TODO: detect if in the correct dir
          echo "storing into '$PWD/flake.nix':"
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
}
