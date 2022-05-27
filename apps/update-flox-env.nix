{ pkgs, floxToml }: {
  type = "app";
  program = let
    extensions = (builtins.fromTOML
      (builtins.readFile floxToml)).floxEnv.programs.vscode.extensions;
    libVscode = (import ../lib/vscode.nix);
  in (pkgs.writeShellApplication {
    name = "update_extensions";
    runtimeInputs = [ pkgs.jq ];
    text = ''
      # shellcheck disable=SC2016
      jq -n --slurpfile vscode <(
        ${./generate_extensions.sh} ${
          toString (libVscode.marketplaceExtensionStrs pkgs extensions)
        }
      ) '{"vscode": $vscode}' > flox-env.lock
    '';
  }) + "/bin/update_extensions";
}
