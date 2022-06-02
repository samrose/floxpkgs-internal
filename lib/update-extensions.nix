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
          res=$({
          echo "'''"
          echo "["
          ${../apps/generate_extensions.sh} ${
            toString (libVscode.marketplaceExtensionStrs pkgs extensions)
          }
          echo "]"
          echo "'''"
          } | flox eval --file - --apply builtins.fromJSON)
          # Reset pins
          # TODO: detect if in the correct dir
          nix-editor flake.nix "outputs.__pins.vscode-extensions" -v "$res" | sponge flake.nix
          alejandra -q flake.nix
        '';
      })
      + "/bin/update-extensions";
  };
}
