rec {
  inputs.capacitor.url = "git+ssh://git@github.com/flox/capacitor?ref=ysndr";
  inputs.capacitor.inputs.root.follows = "/";

  # Add additional subflakes as needed
  inputs.tracelinks.url = "path:./pkgs/tracelinks";

  outputs = _:
    _.capacitor _ ({lib, ...}:
      # Define package set structure
      {
        # Limit the systems to fewer or more than default by ucommenting
        # __systems = ["x86_64-linux"];

        legacyPackages = {pkgs, ...}: {
          nixpkgs = pkgs;
          flox = lib.genAttrs ["stable" "staging" "unstable"] (
            stability:
              {}
              # support flakes approach
              // (lib.flakesWith inputs "capacitor/nixpkgs/nixpkgs-${stability}")
              # support default.nix approach
              // (lib.automaticPkgs ./pkgs pkgs.${stability})
          );
        };
      })
    // {
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
    };

  # API calls
  inputs.cached__nixpkgs-stable__x86_64-linux.url = "https://hydra.floxsdlc.com/channels/nixpkgs/stable/x86_64-linux.tar.gz";
}
