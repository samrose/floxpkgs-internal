rec {
  inputs.capacitor.url = "git+ssh://git@github.com/flox/capacitor";
  inputs.capacitor.inputs.root.follows = "/";

  inputs.floxpkgsv1.url = "git+ssh://git@github.com/flox/floxpkgsv1";
  inputs.floxpkgsv1.flake = false;

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

      packages = args @ {
        system,
        stability ? "unstable",
        ...
      }:
        (legacyPackages (args // {inherit stability;})).flox;

      legacyPackages = {
        root',
        pkgs,
        system,
        stability ? "unstable",
        ...
      }: let
        # Tie-the-knot recursive update required in capacitor
        tie = lib.recursiveUpdate root'.legacyPackages.nixpkgs root'.legacyPackages.flox;
      in {
        # Declare my channels (projects)
        nixpkgs = pkgs.${stability};
        flox =
          # support default.nix approach
          (auto.automaticPkgsWith inputs ./pkgs tie)
          # support flakes approach with override
          # searches in "inputs" for a url with "path:./" and call the flake with the root's lock
          // (lib.sanitizes (lib.callSubflakesWith inputs {}) ["default" "packages" system])
          # External proto-derivaiton trees and overrides
          // (lib.using (import ./flox.nix {_ = _;}) (tie // {inherit inputs;}))
          # end customizations
          ;
      };

      # Create output jobsets for stabilities
      # TODO: has.stabilities and re-arrange attribute names to make system last?
      hydraJobsRaw = {
        lib,
        system,
        pkgs,
        ...
      } @ args:
        lib.genAttrs ["stable" "unstable" "staging"] (
          stability: let
            jobs =
              (legacyPackages (args // {inherit stability;})).flox;
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
        );

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

      hydraJobs = a: (_.self.hydraJobsRaw a);
      hydraJobsStable = lib.genAttrs ["x86_64-linux"] (system: self.hydraJobs.${system}.stable);
      hydraJobsUnstable = lib.genAttrs ["x86_64-linux"] (system: self.hydraJobs.${system}.unstable);
      hydraJobsStaging = lib.genAttrs ["x86_64-linux"] (system: self.hydraJobs.${system}.staging);

      templates = {
        python-black = {
          path = ./templates/python-black;
          description = "Python Black example template";
        };
        python2 = {
          path = ./templates/python2;
          description = "Python 2 template";
        };
        python3 = {
          path = ./templates/python3;
          description = "Python 3 template";
        };
      };
    }));

  # API calls
  inputs.cached__nixpkgs-stable__x86_64-linux.url = "https://hydra.floxsdlc.com/channels/nixpkgs/stable/x86_64-linux.tar.gz";
}
