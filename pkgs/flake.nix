#TODO: Would be in its own repo

{
  # # Add additional subflakes as needed
  inputs.tracelinks.url = "path:./tracelinks";
  inputs.tracelinks.inputs.capacitor.follows = "capacitor";

  inputs.flox.url = "github:flox/flox/minicapacitor";
  inputs.flox.inputs.capacitor.follows = "capacitor";

  inputs.catalog.url = "path:./catalog";
  inputs.catalog.inputs.capacitor.follows = "capacitor";

  # inputs.inputs.url = "path:../";

  outputs = {capacitor, inputs, ...} @ args : capacitor args ({lib, has, auto,...}:
    
    has.projectsFromInputs
    has.localPkgs ./.
    # has.includes { inherit (inputs) nix-installers; }
    {
      # packages = auto.automaticPkgs ./.;
      packages = {

        hello = auto.callPackage ({hello}: hello ) {};
        foo = auto.callPackage ({catalog}: catalog ) {};
        bar = auto.callPackage ({foo}: foo) {};

      } 
      // inputs.nix-installers.protoPackages;

      # __reflect.projects.nix-installers = inputs.nix-installers;
    }
   
  );

}
