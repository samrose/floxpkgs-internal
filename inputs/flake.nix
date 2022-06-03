rec {

  inputs.floxpkgsv1.url = "git+ssh://git@github.com/flox/floxpkgsv1";
  inputs.floxpkgsv1.flake = false;

  inputs."flox/floxdocs/tng".url = "git+ssh://git@github.com/flox/floxdocs?ref=tng";
  inputs."flox/floxdocs/tng".flake = false;

  inputs."flox/mini-dinstall".url = "git+ssh://git@github.com/flox/mini-dinstall?ref=main";
  inputs."flox/mini-dinstall".flake = false;

  inputs.nix-installers.url = "git+ssh://git@github.com/flox/nix-installers?ref=minicapacitor";
  inputs.nix-installers.inputs.capacitor.follows = "capacitor";

  inputs.nixpkgs-stable.url = "github:flox/nixpkgs/stable";
  inputs.nixpkgs-unstable.url = "github:flox/nixpkgs/unstable";
  inputs.nixpkgs-staging.url = "github:flox/nixpkgs/staging";

  outputs = {self, capacitor, ...} @ inputs:  inputs ;

}
