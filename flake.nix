{

  inputs.capacitor.url = "git+ssh://git@github.com/flox/minicapacitor?ref=main";
  inputs.capacitor.inputs.root.follows = "/";

  inputs.nixpkgs-stable.url = "github:flox/nixpkgs/stable";
  inputs.nixpkgs-unstable.url = "github:flox/nixpkgs/unstable";
  inputs.nixpkgs-staging.url = "github:flox/nixpkgs/staging";


  # Add additional subflakes as needed


  inputs."flox/tracelinks".url = "git+ssh://git@github.com/flox/tracelinks?ref=main";
  inputs."flox/tracelinks".flake = false;

  inputs."flox/floxdocs/tng".url = "git+ssh://git@github.com/flox/floxdocs?ref=tng";
  inputs."flox/floxdocs/tng".flake = false;

  inputs."flox/mini-dinstall".url = "git+ssh://git@github.com/flox/mini-dinstall?ref=main";
  inputs."flox/mini-dinstall".flake = false;

  inputs.nix-installers.url = "git+ssh://git@github.com/flox/nix-installers?ref=minicapacitor";
  inputs.nix-installers.inputs.capacitor.follows = "capacitor";

  inputs.catalog.url = "git+ssh://git@github.com/flox/catalog?ref=minicapacitor";
  inputs.catalog.inputs.capacitor.follows = "capacitor";

  inputs.flox.url = "git+ssh://git@github.com/flox/flox?ref=minicapacitor";
  inputs.flox.inputs.capacitor.follows = "capacitor";

  # Third Party

  inputs.nix-editor.url = "github:vlinkz/nix-editor";



  outputs = {capacitor, ...} @ args : capacitor args (import ./flox.nix);

}
