rec {
  inputs.capacitor.url = "git+ssh://git@github.com/flox/capacitor?ref=ysndr";
  inputs.capacitor.inputs.root.follows = "/";

  inputs.tracelinks.url = "path:./pkgs/tracelinks";

  outputs = _: _.capacitor _ ({self,capacitor,auto,...}:
  # {{{
  let
    inherit (import ./helper.nix self capacitor inputs) callSubflakes callSubflakeWith sanitize callSubflake;
    autoSubflakes = callSubflakes {
        inputs.capacitor.inputs.nixpkgs.follows = "capacitor/nixpkgs/nixpkgs-unstable";
    };
    autoSubflakesWith = override: callSubflakes {
        inputs.capacitor.inputs.nixpkgs.follows = override;
    };
    merge = value: builtins.foldl' (acc: x: sanitize acc x) value;
  in
  builtins.mapAttrs (key: value:
    if capacitor.lib.elem key ["legacyPackages" "packages" "hydraJobs" "nixosConfiguraitons" "devShells"]
    then capacitor.lib.genAttrs ["x86_64-linux" "aarch64-linux"] (s: merge value [key s])
    else value)
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
