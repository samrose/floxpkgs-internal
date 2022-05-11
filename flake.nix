rec {
  inputs.nixpkgs-stable.url = "github:flox/nixpkgs/stable";
  inputs.nixpkgs-unstable.url = "github:flox/nixpkgs/unstable";
  inputs.nixpkgs-staging.url = "github:flox/nixpkgs/staging";

  inputs.capacitor.url = "git+ssh://git@github.com/flox/capacitor?ref=ysndr";
  inputs.capacitor.inputs.nixpkgs.follows = "nixpkgs-unstable";

  outputs = {self, capacitor, ...} @ args: (capacitor args ({auto,...}: rec {
    packages = auto.automaticPkgsWith inputs ./pkgs;
    legacyPackages = {system,...}: rec {
      nixpkgs.stable = args.nixpkgs-stable.legacyPackages.${system};
      nixpkgs.unstable = args.nixpkgs-unstable.legacyPackages.${system};
      nixpkgs.staging = args.nixpkgs-staging.legacyPackages.${system};

      flox.unstable = packages nixpkgs.unstable;
      flox.stable = packages nixpkgs.stable;
      flox.staging = packages nixpkgs.staging;
    };
  }));
}

    /*
    Produce a namespace with the following structure:
    legacyPackages.<system>.<channel>.<stability>.<attrPath>
    eg:
    legacyPackages.<system>.nixpkgs.stable.hello
    legacyPackages.<system>.nixpkgs.stable.python3Packages.requests
    legacyPackages.<system>.flox.stable.tracelinks
    legacyPackages.<system>.flox.stable.python3Packages.hello-python-library
    TODO: make a helper for this: has.stabilities ["stable" "unstable" "staging"]
    */
