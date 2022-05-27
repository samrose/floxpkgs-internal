rec {
  inputs.capacitor.url = "git+ssh://git@github.com/flox/capacitor";
  inputs.capacitor.inputs.root.follows = "/";

  inputs.devshell.url = "github:numtide/devshell";

  # TODO: See https://github.com/DavHau/mach-nix/pull/445
  # TODO: using specific revision to bypass mach-nix warning of too new nixpkgs
  #inputs.mach-nix.url = "github:DavHau/mach-nix";
  inputs.mach-nix.url = "github:bjornfor/mach-nix/adapt-to-make-binary-wrapper";
  inputs.mach-nix.inputs.nixpkgs.follows = "nixpkgs-unstable";
  inputs.nixpkgs-unstable.url = "git+ssh://git@github.com/flox/nixpkgs-flox?rev=f5eced6769aaff5658695c281f3831856dbebbc9";
  inputs.mach-nix.inputs.pypi-deps-db.follows = "pypi-deps-db";
  inputs.pypi-deps-db.url = "github:DavHau/pypi-deps-db";
  inputs.pypi-deps-db.flake = false;

  inputs.floxpkgs.url = "git+ssh://git@github.com/flox/floxpkgs";
  inputs.nix-editor.url = "github:vlinkz/nix-editor";

  nixConfig.bash-prompt = "[flox]\\e\[38;5;172mλ \\e\[m";

  outputs = _:
    _.capacitor _ ({
      self,
      devshell,
      auto,
      lib,
      nix-editor,
      ...
    }: {
      devShells = {
        pkgs,
        system,
        ...
      }: let
        tie = {
          inherit pkgs;
          mach = _.mach-nix.lib.${system};
        };
      in {
        default = with pkgs; let
          data = builtins.scopedImport (tie.pkgs // tie.mach) ./flox.nix;
        in
          (devshell.legacyPackages.${system}.mkNakedShell rec {
            name = "ops-env";
            profile = buildEnv {
              name = "wrapper";
              paths = [
                (
                  pkgs.buildEnv (builtins.removeAttrs (data // {name = "fromData";}) ["postShellHook"])
                )
              ];
              postBuild = let
                versioned =
                  builtins.filter (x: builtins.isString x && !builtins.hasContext x)
                  self.devShells.${system}.default.passthru.paths;
                split = map (x: builtins.concatStringsSep " " (lib.strings.splitString "@" x)) versioned;
                envBash = writeTextDir "env.bash" ''
                  ROOT=$(git rev-parse --show-toplevel || echo $HOME/.config/flox/ )
                  rm "$ROOT/.flox-${name}"*
                  ${builtins.concatStringsSep "\n" (map (
                      x: ''
                        echo Searching: "${x}"
                        ref=$( AS_FLAKEREF=1 ${_.floxpkgs.apps.${system}.find-version.program} ${x})
                        echo Installing: "$ref"
                        flox profile install --profile "$ROOT/.flox-${name}" $ref
                      ''
                    )
                    split)}
                  flox profile wipe-history --profile "$ROOT/.flox-${name}" >/dev/null 2>/dev/null
                  export PATH="$ROOT/.flox-${name}/bin:@DEVSHELL_DIR@/bin:$PATH"

                  ${data.postShellHook or ""}

                '';
              in "substitute ${envBash}/env.bash $out/env.bash --subst-var-by DEVSHELL_DIR $out";
            };
          })
          // {passthru = data;};
      };

      apps = {
        pkgs,
        system,
        ...
      }: {
        update-versions = {
          type = "app";
          program =
            (pkgs.writeShellApplication {
              name = "update-versions";
              runtimeInputs = [nix-editor.packages.${system}.nixeditor pkgs.moreutils pkgs.alejandra];
              text = let
                versioned =
                  builtins.filter (x: builtins.isString x && !builtins.hasContext x)
                  self.devShells.${system}.default.passthru.paths;
                split = map (x: builtins.concatStringsSep " " (lib.strings.splitString "@" x)) versioned;
              in ''
                # Reset pins
                nix-editor flake.nix "outputs.__pins" -v "[]" | sponge flake.nix
                ${builtins.concatStringsSep "\n" (map (
                    x: ''
                      res=$(AS_FLAKEREF=1 flox run floxpkgs#find-version ${x})
                      nix-editor flake.nix "outputs.__pins" -a "(builtins.getFlake \"''${res%%\#*}\").''${res##*#}" | sponge flake.nix
                      alejandra -q flake.nix
                    ''
                  )
                  split)}
              '';
            })
            + "/bin/update-versions";
        };
      };

      # Auto-managed vvvvvv
      __pins = [
        (builtins.getFlake "github:flox/nixpkgs/90705c89fbad69c4c971fabf2b1edd8c7875b5d6").legacyPackages.x86_64-linux.kubernetes-helm
      ];
      # TODO: Due to a limitation in nix-editor, unable to add a new nested attrset value.
      # Instead using a list as a workaround, then fixing it
      pins = builtins.listToAttrs (map (x: {
          name = builtins.replaceStrings ["."] ["_"] x.name;
          value = x;
        })
        self.__pins);
      # Auto-managed ^^^^^^
    });
}
