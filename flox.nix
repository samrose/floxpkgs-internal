context @ { inputs, ... }: {
  packages = {
    flox = { self', ... }: self'.legacyPackages.__projects.flox.default;
  };

  __reflect = {

    stabilities = rec {
      stable = inputs.nixpkgs-stable;
      unstable = inputs.nixpkgs-unstable;
      staging = inputs.nixpkgs-staging;
      default = stable;
    };

    systems = [ "x86_64-linux" ];

    adopted = {
      inherit (inputs) nix-installers;
    };

    projects = {
      flox = inputs.flox;
    };

  };
}
