{
  inputs.capacitor.url = "git+ssh://git@github.com/flox/minicapacitor?ref=main&dir=capacitor";
  inputs.capacitor.inputs.root.follows = "/";

  inputs.nixpkgs-stable.url = "github:flox/nixpkgs/stable";
  inputs.nixpkgs-unstable.url = "github:flox/nixpkgs/unstable";
  inputs.nixpkgs-staging.url = "github:flox/nixpkgs/staging";


  # Used for ops-env library functions. TODO: move to capacitor?
  # inputs.devshell.url = "github:numtide/devshell";
  # inputs.mach-nix.url = "github:DavHau/mach-nix";
  # inputs.mach-nix.inputs.nixpkgs.follows = "nixpkgs";
  # inputs.mach-nix.inputs.pypi-deps-db.follows = "pypi-deps-db";
  # inputs.pypi-deps-db.url = "github:DavHau/pypi-deps-db";
  # inputs.pypi-deps-db.flake = false;
  # inputs.nix-editor.url = "github:vlinkz/nix-editor";


  # outputs = _: (_.capacitor _ ({
  #     self,
  #     lib,
  #     auto,
  #     ...
  #   }:
  #   # Define package set structure
  #   rec {
  #     # Limit the systems to fewer or more than default by ucommenting
  #     # __systems = ["x86_64-linux"];

  #     packages = args: (legacyPackages args).flox;

  #     legacyPackages = {
  #       pkgs,
  #       system,
  #       stability ? "unstable",
  #       ...
  #     }: rec {
  #       # Declare my channels (projects)
  #       nixpkgs = pkgs.${stability};
  #       flox =
  #         # support default.nix approach
  #         (auto.automaticPkgsWith inputs ./pkgs (lib.recursiveUpdate nixpkgs flox))
  #         # support flakes approach with override
  #         # searches in "inputs" for a url with "path:./" and call the flake with the root's lock
  #         // (lib.sanitizes (auto.callSubflakesWith inputs "path:./pkgs" {}) ["pins" "default" "packages" system])
  #         # External proto-derivaiton trees and overrides
  #         // (
  #           auto.usingWith inputs (import ./flox.nix {_ = _;}) (lib.recursiveUpdate nixpkgs flox)
  #         )
  #         # end customizations
  #         ;
  #     };

  #     apps = {pkgs, ...}: auto.automaticPkgsWith inputs ./apps;

  #     # Create output jobsets for stabilities
  #     # TODO: has.stabilities and re-arrange attribute names to make system last?
  #     hydraJobsRaw = lib.genAttrs ["stable" "unstable" "staging"] (stability:
  #       lib.genAttrs ["x86_64-linux"] (
  #         system: let
  #           args = {
  #             inherit lib system;
  #             root' = _.capacitor.lib.sanitize _.capacitor.inputs.root system;
  #             pkgs = _.nixpkgs.legacyPackages.${system};
  #             inherit stability;
  #           };
  #           jobs = (legacyPackages args).flox;
  #           pkgs = (legacyPackages args).nixpkgs;
  #         in
  #           jobs
  #           // {
  #             gate =
  #               pkgs.runCommand "all-jobs" rec {
  #                 _hydraAggregate = true;
  #                 constituentList = lib.collect lib.isList (
  #                   lib.mapAttrsRecursiveCond
  #                   (value: !(lib.isDerivation value))
  #                   (path: value: path)
  #                   jobs
  #                 );
  #                 constituents = with builtins;
  #                   map (x: concatStringsSep "." ([system] ++ x)) constituentList;
  #               } ''
  #                 touch $out
  #               '';
  #           }
  #       ));
  #     hydraJobsStable = self.hydraJobsRaw.stable;
  #     hydraJobsUnstable = self.hydraJobsRaw.unstable;
  #     hydraJobsStaging = self.hydraJobsRaw.staging;

  #     catalog =
  #       (_.capacitor.lib.project _ ({...}: {
  #         legacyPackages = args @ {system, ...}:
  #           lib.genAttrs ["flox" "nixpkgs"] (channel:
  #             lib.genAttrs ["stable" "unstable" "staging"] (
  #               stability:
  #                 (legacyPackages (args // {inherit stability;})).${channel}
  #             ));
  #       }))
  #       .legacyPackages;

  #     devShells = {system, ...}: {
  #       ops-env = (auto.subflake "templates/ops-env" "ops-env" {} {}).devShells.${system}.default;
  #     };

  #     lib =
  #       _.capacitor.lib
  #       // {
  #         flox-env = import ./lib/flox-env.nix;
  #         vscode = import ./lib/vscode.nix;
  #         mkNakedShell = import ./lib/mkNakedShell.nix;
  #         mkFloxShell = import ./lib/mkFloxShell.nix _;
  #         mkUpdateVersions = import ./lib/update-versions.nix _;
  #       };


  inputs.pkgs.url = "path:./pkgs";
  inputs.pkgs.inputs.capacitor.follows = "capacitor";

  # inputs.ops-env.url = "path:../templates/ops-env";
  # inputs.ops-env.inputs.capacitor.follows = "capacitor";
  # inputs.ops-env.inputs.floxpkgs.follows = "/";


  nixConfig.bash-prompt = "[flox]\\e\[38;5;172mλ \\e\[m";

  outputs = { capacitor, ... } @ args: capacitor args ({  lib
                                                               , auto
                                                               , has
                                                               , ...
                                                               }:

    has.stabilities
      rec {
        stable = args.nixpkgs-stable;
        unstable = args.nixpkgs-unstable;
        staging = args.nixpkgs-staging;
        default = stable;
      }
      has.systems ["x86_64-linux"]
      {
        __reflect = {
          projects = {
            pkgs = auto.callSubflake "pkgs" {};
          };
        };

        # Define package set structure
        # rec {

        #   packages = args @ {
        #     system,
        #     stability ? "unstable",
        #     ...
        #   }:
        #     (legacyPackages (args // {inherit stability;})).flox;

        #   legacyPackages = {
        #     root',
        #     pkgs,
        #     system,
        #     stability ? "unstable",
        #     ...
        #   }: let
        #     # Tie-the-knot recursive update required in capacitor
        #     tie = lib.recursiveUpdate root'.legacyPackages.nixpkgs root'.legacyPackages.flox;
        #   in {
        #     # Declare my channels (projects)
        #     nixpkgs = pkgs.${stability};
        #     flox =
        #       # support default.nix approach
        #       (auto.automaticPkgsWith inputs ./pkgs tie)
        #       # support flakes approach with override
        #       # searches in "inputs" for a url with "path:./" and call the flake with the root's lock
        #       // (lib.sanitizes (auto.callSubflakesWith inputs {}) ["pins" "default" "packages" system])
        #       # External proto-derivaiton trees and overrides
        #       // (auto.usingWith inputs (import ./flox.nix {_ = _;}) tie
        #       )
        #       # end customizations
        #       ;
        #   };

        #   apps = {pkgs,...}: auto.automaticPkgsWith inputs ./apps;

        #   # Create output jobsets for stabilities
        #   # TODO: has.stabilities and re-arrange attribute names to make system last?
        #   hydraJobsRaw = {
        #     lib,
        #     system,
        #     pkgs,
        #     ...
        #   } @ args:
        #     lib.genAttrs ["stable" "unstable" "staging"] (
        #       stability: let
        #         jobs =
        #           (legacyPackages (args // {inherit stability;})).flox;
        #       in
        #         jobs
        #         // {
        #           gate =
        #             pkgs.runCommand "all-jobs" rec {
        #               _hydraAggregate = true;
        #               constituentList = lib.collect lib.isList (
        #                 lib.mapAttrsRecursiveCond
        #                 (value: !(lib.isDerivation value))
        #                 (path: value: path)
        #                 jobs
        #               );
        #               constituents = with builtins;
        #                 map (x: concatStringsSep "." ([system] ++ x)) constituentList;
        #             } ''
        #               touch $out
        #             '';
        #         }
        #     );

        #   catalog =
        #     (_.capacitor.lib.project _ ({...}: {
        #       legacyPackages = args @ {system, ...}:
        #         lib.genAttrs ["flox" "nixpkgs"] (channel:
        #           lib.genAttrs ["stable" "unstable" "staging"] (
        #             stability:
        #               (legacyPackages (args // {inherit stability;})).${channel}
        #           ));
        #     }))
        #     .legacyPackages;

        #   hydraJobs = a: (_.self.hydraJobsRaw a);
        #   hydraJobsStable = lib.genAttrs ["x86_64-linux"] (system: self.hydraJobs.${system}.stable);
        #   hydraJobsUnstable = lib.genAttrs ["x86_64-linux"] (system: self.hydraJobs.${system}.unstable);
        #   hydraJobsStaging = lib.genAttrs ["x86_64-linux"] (system: self.hydraJobs.${system}.staging);

        #   devShells = {system,root',...}: let
        #     tie = lib.recursiveUpdate root'.legacyPackages.nixpkgs root'.legacyPackages.flox;
        #   in {
        #      ops-env = (auto.subflake "templates/ops-env" "ops-env" {} {}).devShells.${system}.default;
        #   };

         lib =
            _.capacitor.lib
            // {
              flox-env = import ./lib/flox-env.nix;
              vscode = import ./lib/vscode.nix;
              mkNakedShell = import ./lib/mkNakedShell.nix;
              mkFloxShell = import ./lib/mkFloxShell.nix _;
              mkUpdateVersions = import ./lib/update-versions.nix _;
              mkUpdateExtensions = import ./lib/update-extensions.nix _;
            };

        templates = builtins.mapAttrs
          (k: v: {
            path = v.path;
            description = (import (v.path + "/flake.nix")).description or "no description provided in ${v.path}/flake.nix";
          })
          (capacitor.lib.dirToAttrs ./templates { });
      }
  );

}
