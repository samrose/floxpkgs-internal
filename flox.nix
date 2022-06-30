context @ { lib, inputs, ... }: {
  packages = {
    nixeditor = { inputs, ... }: inputs.nix-editor.packages.nixeditor;
    flox = { inputs, ... }: inputs.flox.legacyPackages.default;
  };

  config = {

    stabilities = rec {
      stable = inputs.nixpkgs-stable;
      unstable = inputs.nixpkgs-unstable;
      staging = inputs.nixpkgs-staging;
      default = stable;
    };

    systems = [ "x86_64-linux" ];

    adopted = {
      inherit (inputs) flox nix-installers;
    };

    projects = {
      inherit (inputs)  nix-editor catalog;
    };

    extraPlugins = [
      (inputs.capacitor.plugins.allLocalResources {})
      (inputs.capacitor.plugins.templates {})
    ];

  };
}
