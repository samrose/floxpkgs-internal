{
  inputs.capacitor.url = "/Volumes/Projects/Flox/tests/minicapacitor/capacitor";
  # inputs.capacitor.url = "git+ssh://git@github.com/flox/minicapacitor?ref=main&dir=capacitor";

  inputs.capacitor.inputs.root.follows = "/";

  inputs.nixpkgs-stable.url = "github:flox/nixpkgs/stable";
  inputs.nixpkgs-unstable.url = "github:flox/nixpkgs/unstable";
  inputs.nixpkgs-staging.url = "github:flox/nixpkgs/staging";


  # # Add additional subflakes as needed
  inputs.tracelinks.url = "path:./pkgs/tracelinks";
  inputs.tracelinks.inputs.capacitor.follows = "capacitor";

  inputs.catalog.url = "path:./pkgs/catalog";
  inputs.catalog.inputs.capacitor.follows = "capacitor";

  inputs."nix-editor".url = "path:./pkgs/nix-editor";
  inputs."nix-editor".inputs.capacitor.follows = "capacitor";

  inputs.flox.url = "git+ssh://git@github.com/flox/flox?ref=minicapacitor";
  inputs.flox.inputs.capacitor.follows = "capacitor";

  inputs."flox/floxdocs/tng".url = "git+ssh://git@github.com/flox/floxdocs?ref=tng";
  inputs."flox/floxdocs/tng".flake = false;

  inputs."flox/mini-dinstall".url = "git+ssh://git@github.com/flox/mini-dinstall?ref=main";
  inputs."flox/mini-dinstall".flake = false;

  inputs.nix-installers.url = "git+ssh://git@github.com/flox/nix-installers?ref=minicapacitor";
  inputs.nix-installers.inputs.capacitor.follows = "capacitor";


  outputs = {capacitor, ...} @ args : capacitor args (context @ {has, lib,auto,...}:
      
      lib.recursiveUpdate
      {
        packages = (auto.localPkgs context "pkgs/");
        lib = (auto.localX "lib" context "lib/");
        apps = (auto.localX "apps" context "apps/");

        templates = builtins.mapAttrs
          (k: v: {
            path = v.path;
            description = (import (v.path + "/flake.nix")).description or "no description provided in ${v.path}/flake.nix";
          })
          (capacitor.lib.dirToAttrs ./templates { });
      }
      (import ./flox.nix context)



   
  );

}
