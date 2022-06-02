rec {
  # inputs.capacitor.url = "git+ssh://git@github.com/flox/capacitor";
  inputs.capacitor.url = "path:/home/tom/flox/capacitor";
  inputs.capacitor.inputs.root.follows = "/";

  inputs.floxdocs.url = "git+ssh://git@github.com/flox/floxdocs?ref=tng";
  inputs.floxdocs.flake = false;

  inputs."mini-dinstall".url = "git+ssh://git@github.com/flox/mini-dinstall?ref=main";
  inputs."mini-dinstall".flake = false;

  inputs.nix-installers.url = "git+ssh://git@github.com/flox/nix-installers";
  inputs.nix-installers.flake = false;

  # This is a misnomer, it's is nixpkgs w/stabilties
  inputs.nixpkgs.url = "git+ssh://git@github.com/flox/nixpkgs-flox";
  inputs.nixpkgs.inputs.capacitor.follows = "capacitor";
  inputs.capacitor.inputs.nixpkgs.follows = "nixpkgs";

  # Add additional subflakes as needed
  inputs.tracelinks.url = "path:./pkgs/tracelinks";
  inputs.flox.url = "path:./pkgs/flox";
  inputs.catalog.url = "path:./pkgs/catalog";
  inputs.ops-env.url = "path:./templates/ops-env";
  inputs.ops-env.inputs.capacitor.follows = "capacitor";
  inputs.ops-env.inputs.floxpkgs.follows = "/";
  inputs.ops-env.inputs.nixpkgs.follows = "nixpkgs";

  # Used for ops-env library functions. TODO: move to capacitor?
  inputs.devshell.url = "github:numtide/devshell";
  inputs.mach-nix.url = "github:DavHau/mach-nix";
  inputs.mach-nix.inputs.nixpkgs.follows = "nixpkgs";
  inputs.mach-nix.inputs.pypi-deps-db.follows = "pypi-deps-db";
  inputs.pypi-deps-db.url = "github:DavHau/pypi-deps-db";
  inputs.pypi-deps-db.flake = false;
  inputs.nix-editor.url = "github:vlinkz/nix-editor";

  nixConfig.bash-prompt = "[flox]\\e\[38;5;172mλ \\e\[m";

  outputs = _: (_.capacitor _ ({
      self,
      lib,
      auto,
      ...
    }:
    # Define package set structure
    rec {
      # Limit the systems to fewer or more than default by ucommenting
      # __systems = ["x86_64-linux"];

      packages = args: (legacyPackages args).flox;

      legacyPackages = {
        pkgs,
        system,
        stability ? "unstable",
        ...
      }: rec {
        # Declare my channels (projects)
        nixpkgs = pkgs.${stability};
        flox =
          # support default.nix approach
          (auto.automaticPkgsWith inputs ./pkgs (lib.recursiveUpdate nixpkgs flox))
          # support flakes approach with override
          # searches in "inputs" for a url with "path:./" and call the flake with the root's lock
          // (lib.sanitizes (auto.callSubflakesWith inputs "path:./pkgs" {}) ["pins" "default" "packages" system])
          # External proto-derivaiton trees and overrides
          // (
            auto.usingWith inputs (import ./flox.nix {_ = _;}) (lib.recursiveUpdate nixpkgs flox)
          )
          # end customizations
          ;
      };

      apps = {pkgs, ...}: auto.automaticPkgsWith inputs ./apps;

      # Create output jobsets for stabilities
      # TODO: has.stabilities and re-arrange attribute names to make system last?
      hydraJobsRaw = lib.genAttrs ["stable" "unstable" "staging"] (stability:
        lib.genAttrs ["x86_64-linux"] (
          system: let
            args = {
              inherit lib system;
              root' = _.capacitor.lib.sanitize _.capacitor.inputs.root system;
              pkgs = _.nixpkgs.legacyPackages.${system};
              inherit stability;
            };
            jobs = (legacyPackages args).flox;
            pkgs = (legacyPackages args).nixpkgs;
          in
            jobs
            // {
              gate =
                pkgs.runCommand "all-jobs" rec {
                  _hydraAggregate = true;
                  constituentList = lib.collect lib.isList (
                    lib.mapAttrsRecursiveCond
                    (value: !(lib.isDerivation value))
                    (path: value: path)
                    jobs
                  );
                  constituents = with builtins;
                    map (x: concatStringsSep "." ([system] ++ x)) constituentList;
                } ''
                  touch $out
                '';
            }
        ));
      hydraJobsStable = self.hydraJobsRaw.stable;
      hydraJobsUnstable = self.hydraJobsRaw.unstable;
      hydraJobsStaging = self.hydraJobsRaw.staging;

      catalog =
        (_.capacitor.lib.project _ ({...}: {
          legacyPackages = args @ {system, ...}:
            lib.genAttrs ["flox" "nixpkgs"] (channel:
              lib.genAttrs ["stable" "unstable" "staging"] (
                stability:
                  (legacyPackages (args // {inherit stability;})).${channel}
              ));
        }))
        .legacyPackages;

      devShells = {system, ...}: {
        ops-env = (auto.subflake "templates/ops-env" "ops-env" {} {}).devShells.${system}.default;
      };

      lib =
        _.capacitor.lib
        // {
          flox-env = import ./lib/flox-env.nix;
          vscode = import ./lib/vscode.nix;
          mkNakedShell = import ./lib/mkNakedShell.nix;
          mkFloxShell = import ./lib/mkFloxShell.nix self _;
          mkUpdateVersions = import ./lib/update-versions.nix _;
        };

        templates = builtins.mapAttrs (k: v: {
          path = v.path;
          description = (import (v.path + "/flake.nix")).description or "no description provided in ${v.path}/flake.nix";
        }) (_.capacitor.lib.dirToAttrs ./templates {});

    }));

  # API calls
  inputs.cached__nixpkgs-stable__x86_64-linux.url = "https://hydra.floxsdlc.com/channels/nixpkgs/stable/x86_64-linux.tar.gz";
}
