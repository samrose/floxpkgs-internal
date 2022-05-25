rec {
  inputs.capacitor.url = "git+ssh://git@github.com/flox/capacitor";
  inputs.capacitor.inputs.root.follows = "/";

  inputs.devshell.url = "github:numtide/devshell";
  inputs.mach-nix.url = "github:DavHau/mach-nix";

  inputs.floxpkgs.url = "git+ssh://git@github.com/flox/floxpkgs";

  nixConfig.bash-prompt = "[flox]\\e\[38;5;172mλ \\e\[m";

  outputs = _:
    _.capacitor _ ({
      self,
      devshell,
      auto,
      lib,
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
          (devshell.legacyPackages.${system}.mkNakedShell {
            name = "thing";
            profile = buildEnv {
              name = "wrapper";
              paths = [
                (
                  pkgs.buildEnv (data // {name = "fromData";})
                )
              ];
              postBuild = let
                versioned =
                  builtins.filter (x: builtins.isString x && !builtins.hasContext x)
                  self.devShells.${system}.default.passthru.paths;
                split = map (x: builtins.concatStringsSep " " (lib.strings.splitString "@" x)) versioned;
                envBash = writeTextDir "env.bash" ''
                  ROOT=$(git rev-parse --show-toplevel)
                  rm "$ROOT/.flox"*
                  ${builtins.concatStringsSep "\n" (map (
                    x: ''
                    echo Searching: "${x}"
                    ref=$( AS_FLAKEREF=1 ${_.floxpkgs.apps.${system}.find-version.program} ${x})
                    echo Installing: "$ref"
                    flox profile install --profile "$ROOT/.flox" $ref
                      ''
                    ) split)}
                  flox profile wipe-history --profile "$ROOT/.flox" >/dev/null 2>/dev/null
                  export PATH="$ROOT/.flox/bin:@DEVSHELL_DIR@/bin:$PATH"

                '';
              in "substitute ${envBash}/env.bash $out/env.bash --subst-var-by DEVSHELL_DIR $out";
            };
          })
          // {passthru = data;};
      };


      apps = {pkgs,system,...}: {
        # find-versions = {
        #   type = "app";
        #   program = (pkgs.writeShellApplication {
        #     name = "find-versions";
        #     text =
        #         ''
        #           echo ${builtins.concatStringsSep " " versioned}
        #       '';
        #   }) + "/bin/update-versions";
        # };
        update-versions = {
          type = "app";
          program = (pkgs.writeShellApplication {
            name = "update-versions";
            text = let
              versioned =
              builtins.filter (x: builtins.isString x && !builtins.hasContext x)
              self.devShells.${system}.default.passthru.paths;
            in
                ''
                  echo ${builtins.concatStringsSep " " versioned}
              '';
          }) + "/bin/update-versions";
        };
      };
      # __pins = {
      #   "kubernetes@3.6" = (builtins.getFlake "sadfasdfasdfasf").legacyPackages.asdfasdf.hello;
      # };

    });
}
