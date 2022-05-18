rec {
  inputs.capacitor.url = "git+ssh://git@github.com/flox/capacitor";
  inputs.capacitor.inputs.root.follows = "/";

  inputs.floxpkgsv1.url = "git+ssh://git@github.com/flox/floxpkgsv1";
  inputs.floxpkgsv1.flake = false;

  inputs.floxdocs.url = "git+ssh://git@github.com/flox/floxdocs?ref=tng";
  inputs.floxdocs.flake = false;

  inputs.nix-installers.url = "git+ssh://git@github.com/flox/nix-installers?ref=flox-hacks";
  inputs.nix-installers.flake = false;

  # Recover older behavior while we remove stabilities
  inputs.nixpkgs.url = "git+ssh://git@github.com/flox/nixpkgs-flox";
  inputs.capacitor.inputs.nixpkgs.follows = "nixpkgs";

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

        legacyPackages = {self',root', pkgs, system, ...}: {
          nixpkgs = { inherit (pkgs) stable unstable staging; };
          flox = lib.genAttrs ["stable" "unstable" "staging"] (stability:
            {}
            //

            # support flakes approach with override
            # TODO: hide the sanitization
            (lib.sanitizes (lib.flakesWith inputs "capacitor/nixpkgs/nixpkgs-${stability}" ) [ "default" "packages" system ])

            # support default.nix approach
            // (auto.automaticPkgsWith inputs ./pkgs (
              (lib.recursiveUpdate
              root'.legacyPackages.nixpkgs.${stability}
              root'.legacyPackages.flox.${stability}
              )
              )
              )

            # bring in floxdocs using only proto-derivations
            // ({
                python3Packages = auto.automaticPkgsWith inputs (_.floxpkgsv1 + "/pythonPackages") pkgs.${stability}.python3Packages;
                }
              )
            // (
              {
                floxdocs = pkgs.${stability}.callPackage ./pkgs/floxdocs/default.nix ({
                  src = _.floxdocs;
                  python3Packages = # root'.legacyPackages.flox.${stability}.python3Packages;
                    (lib.recursiveUpdate
                    root'.legacyPackages.nixpkgs.${stability}.python3Packages
                    root'.legacyPackages.flox.${stability}.python3Packages
                    );
              });
              }
              )
            // (
              # TODO: why does an overridable derivation cause recursion?
              builtins.mapAttrs (_: v:
              builtins.removeAttrs v
              ["override" "__functor" "overrideDerivation" ]
              # []
              )
              (lib.using {
                nix-installers = _.nix-installers.outPath;
              } (
                  root'.legacyPackages.nixpkgs.${stability}
                  //
                  root'.legacyPackages.flox.${stability}
                  ) // {
                  pkgs = root'.legacyPackages.nixpkgs.${stability};
                  })
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
      hydraJobsRaw =
        with _.capacitor.inputs.nixpkgs-lib;
          lib.genAttrs ["stable" "unstable" "staging"] (stability:

          lib.genAttrs ["x86_64-linux"] (system:
          lib.genAttrs (builtins.attrNames _.self.legacyPackages.x86_64-linux.flox.unstable) (attr:
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
