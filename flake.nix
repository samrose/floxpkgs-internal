rec {
  inputs.capacitor.url = "git+ssh://git@github.com/flox/capacitor";
  inputs.capacitor.inputs.root.follows = "/";

  inputs.floxpkgsv1.url = "git+ssh://git@github.com/flox/floxpkgsv1";
  inputs.floxpkgsv1.flake = false;

  # inputs.nixpkgs.url = "git+ssh://git@github.com/flox/nixpkgs-flox";

  # Add additional subflakes as needed
  inputs.tracelinks.url = "path:./pkgs/tracelinks";
  inputs.flox.url = "path:./pkgs/flox";
  inputs.catalog.url = "path:./pkgs/catalog";

  outputs = _:
    (_.capacitor _ ({
        lib,
        auto,
        ...
      }:
      # Define package set structure
      {
        # Limit the systems to fewer or more than default by ucommenting
        # __systems = ["x86_64-linux"];

        legacyPackages = {pkgs, system, ...}: {
          nixpkgs = pkgs;
          flox = lib.genAttrs ["stable" "unstable" "staging"] (stability:
            {}
            # support flakes approach with override
            //
            (lib.sanitizes
            (lib.flakesWith inputs "capacitor/nixpkgs/nixpkgs-${stability}" )
            [ "default" "packages" system ]
            )
            # support default.nix approach
            // (auto.automaticPkgsWith inputs ./pkgs pkgs.${stability})
            // (
              auto.automaticPkgsWith inputs (_.floxpkgsv1 + "/pythonPackages") pkgs.${stability}.python3Packages
              # using pkgs rec {
          # default = ./default.nix;
          # python3Packages = automaticPkgs (floxpkgs + "/pythonPackages") pkgs.python3Packages;

              )
            );
        };

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
      hydraJobsStable = _.self.hydraJobs.stable;
      hydraJobsUnstable = _.self.hydraJobs.unstable;
      hydraJobsStaging = _.self.hydraJobs.staging;
      hydraJobs =
        with _.capacitor.inputs.nixpkgs-lib;
          lib.genAttrs ["stable" "unstable" "staging"] (stability:
          lib.genAttrs (builtins.attrNames _.self.legacyPackages.x86_64-linux.flox.unstable) (attr:
          lib.genAttrs ["x86_64-linux"] (system:
            _.self.legacyPackages.${system}.flox.${stability}.${attr}
          )
          )
        );

      }))
    // {
      /**/
    };

  # API calls
  inputs.cached__nixpkgs-stable__x86_64-linux.url = "https://hydra.floxsdlc.com/channels/nixpkgs/stable/x86_64-linux.tar.gz";
}
