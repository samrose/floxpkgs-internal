rec {
  inputs.capacitor.url = "git+ssh://git@github.com/flox/capacitor";
  inputs.capacitor.inputs.root.follows = "/";

  inputs.floxpkgsv1.url = "git+ssh://git@github.com/flox/floxpkgsv1";
  inputs.floxpkgsv1.flake = false;

  inputs.floxdocs.url = "git+ssh://git@github.com/flox/floxdocs?ref=tng";
  inputs.floxdocs.flake = false;

  inputs.nix-installers.url = "git+ssh://git@github.com/flox/nix-installers?ref=flox-hacks";
  inputs.nix-installers.flake = false;

  inputs.nixpkgs.url = "git+ssh://git@github.com/flox/nixpkgs-flox";
  inputs.capacitor.inputs.nixpkgs.follows = "nixpkgs";

  # Add additional subflakes as needed
  inputs.tracelinks.url = "path:./pkgs/tracelinks";
  inputs.flox.url = "path:./pkgs/flox";
  inputs.catalog.url = "path:./pkgs/catalog";

  outputs = _:
    (_.capacitor _ ({
        self,
        lib,
        auto,
        ...
      }:
      # Define package set structure
      rec {
        # Limit the systems to fewer or more than default by ucommenting
        # __systems = ["x86_64-linux"];

        legacyPackages = {
          self',
          root',
          pkgs,
          system,
          stability ? "unstable",
          ...
        }: {
          nixpkgs = pkgs.${stability};
          flox =
            let
              tie = (
                lib.recursiveUpdate
                root'.legacyPackages.nixpkgs
                root'.legacyPackages.flox
              );
            in
              # support default.nix approach
              (auto.automaticPkgsWith inputs ./pkgs tie)
              # support flakes approach with override
              # TODO: hide the sanitization
              // (lib.sanitizes (lib.callSubflakesWith inputs {}) ["default" "packages" system])
              # External proto-derivaiton trees and overrides
              // (lib.using
                {
                  nix-installers = _.nix-installers + "/default.nix";
                  python3Packages = _.floxpkgsv1 + "/pythonPackages";
                } (tie // {inherit inputs;}))
            # end customizations
            ;
        };

        # Create output jobsets for stabilities
        # First, re-evaluate legacyPackages with alternates
        # Second, expose specific branches at top-level
        hydraJobs = args:
          lib.genAttrs ["stable" "unstable" "staging"] (
            stability:
              (legacyPackages (args // {inherit stability;})).flox
          );
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
      }))
    // {
      /**/
    };

  # API calls
  inputs.cached__nixpkgs-stable__x86_64-linux.url = "https://hydra.floxsdlc.com/channels/nixpkgs/stable/x86_64-linux.tar.gz";
}
