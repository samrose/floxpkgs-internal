#TODO: Would be in its own repo

{
  # # Add additional subflakes as needed
  inputs.tracelinks.url = "path:./tracelinks";
  inputs.tracelinks.inputs.capacitor.follows = "capacitor";

  inputs.catalog.url = "path:./catalog";
  inputs.catalog.inputs.capacitor.follows = "capacitor";

  inputs.flox.url = "git+ssh://git@github.com/flox/flox?ref=minicapacitor";
  inputs.flox.inputs.capacitor.follows = "capacitor";

  inputs."flox/floxdocs/tng".url = "git+ssh://git@github.com/flox/floxdocs?ref=tng";
  inputs."flox/floxdocs/tng".flake = false;

  inputs."flox/mini-dinstall".url = "git+ssh://git@github.com/flox/mini-dinstall?ref=main";
  inputs."flox/mini-dinstall".flake = false;

  inputs.nix-installers.url = "git+ssh://git@github.com/flox/nix-installers?ref=minicapacitor";
  inputs.nix-installers.inputs.capacitor.follows = "capacitor";


  outputs = {capacitor, nix-installers, ...} @ args : capacitor args ({lib, has, auto,...}:
    
    has.projects {
      catalog = auto.callSubflake "catalog" {};
      tracelinks = auto.callSubflake "tracelinks" {};
      flox = args.flox;
    }

    has.localPkgs ./.
    # has.includes { inherit (inputs) nix-installers; }
    {
      # packages = auto.automaticPkgs ./.;
      packages = {

        hello = auto.callPackage ({hello}: hello ) {};
        foo = auto.callPackage ({flox}: flox ) {};
        bar = auto.callPackage ({foo}: foo) {};

      }
      // nix-installers.protoPackages;

      __reflect.subflakePath = "pkgs";
      # __reflect.projects.nix-installers = inputs.nix-installers;
    }
   
  );

}
