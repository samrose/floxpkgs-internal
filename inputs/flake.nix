rec {

  inputs.floxpkgsv1.url = "git+ssh://git@github.com/flox/floxpkgsv1";
  inputs.floxpkgsv1.flake = false;

  inputs.floxdocs.url = "git+ssh://git@github.com/flox/floxdocs?ref=tng";
  inputs.floxdocs.flake = false;

  inputs."mini-dinstall".url = "git+ssh://git@github.com/flox/mini-dinstall?ref=main";
  inputs."mini-dinstall".flake = false;

  inputs.nix-installers.url = "git+ssh://git@github.com/flox/nix-installers";
  inputs.nix-installers.flake = false;

  inputs.nixpkgs-stable.url = "github:flox/nixpkgs/stable";
  inputs.nixpkgs-unstable.url = "github:flox/nixpkgs/unstable";
  inputs.nixpkgs-staging.url = "github:flox/nixpkgs/staging";

  outputs = {self, ...} @ inputs:  inputs ;

}
