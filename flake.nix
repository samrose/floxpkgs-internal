rec {
  inputs.capacitor.url = "git+ssh://git@github.com/flox/capacitor?ref=ysndr";
  inputs.capacitor.inputs.root.follows = "/";

  inputs.tracelinks.url = "path:./pkgs/tracelinks";

  outputs = _: _.capacitor _ ({self,capacitor,auto,...}:
  # boilerplate {{{
  let
    inherit (import ./helper.nix self capacitor inputs) autoSubflakesWith mapRoot;
  in
  mapRoot
    # }}}
  {
    packages = autoSubflakesWith "capacitor/nixpkgs/nixpkgs-unstable";

    legacyPackages = {
      nixpkgs = capacitor.inputs.nixpkgs;
      flox = {
        stable = autoSubflakesWith "capacitor/nixpkgs/nixpkgs-stable";
        unstable = autoSubflakesWith "capacitor/nixpkgs/nixpkgs-unstable";
        staging = autoSubflakesWith "capacitor/nixpkgs/nixpkgs-staging";
      };
    };
  });

  # API calls
  inputs.cached__nixpkgs-stable__x86_64-linux.url = "https://hydra.floxsdlc.com/channels/nixpkgs/stable/x86_64-linux.tar.gz";
}
