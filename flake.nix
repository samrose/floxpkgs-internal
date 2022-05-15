rec {
  inputs.capacitor.url = "git+ssh://git@github.com/flox/capacitor?ref=ysndr";
  inputs.capacitor.inputs.root.follows = "/";

  inputs.tracelinks.url = "path:./pkgs/tracelinks";

  outputs = {
    self,
    capacitor,
    ...
  } @ args: let
    inherit (import ./helper.nix self capacitor inputs) callSubflakes callSubflakeWith;
  in
    capacitor args ({auto, ...}: {

      packages = {pkgs, ...}: {
        tracelinks = callSubflakeWith pkgs "tracelinks" {
          inputs.capacitor.inputs.nixpkgs.follows = "capacitor/nixpkgs/nixpkgs-unstable";
        };
      };

      legacyPackages = {pkgs, ...}: {
        nixpkgs = pkgs;
        flox = capacitor.lib.recurseIntoAttrs2 {
            # Protect from shadowing names
            unstable = callSubflakes pkgs {
              inputs.capacitor.inputs.nixpkgs.follows = "capacitor/nixpkgs/nixpkgs-unstable";
            };
            stable = callSubflakes pkgs {
              inputs.capacitor.inputs.nixpkgs.follows = "capacitor/nixpkgs/nixpkgs-stable";
            };
            staging = callSubflakes pkgs {
              inputs.capacitor.inputs.nixpkgs.follows = "capacitor/nixpkgs/nixpkgs-staging";
            };
          };

        # Provide built invariant {{{
        cached.nixpkgs.stable =
          if pkgs.system or pkgs.unstable.system == "x86_64-linux"
          then args.cached__nixpkgs-stable__x86_64-linux.legacyPackages.${pkgs.system or pkgs.unstable.system}
          else {}; # }}}
      };
    });

  # API calls
  inputs.cached__nixpkgs-stable__x86_64-linux.url = "https://hydra.floxsdlc.com/channels/nixpkgs/stable/x86_64-linux.tar.gz";
}
