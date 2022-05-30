#TODO: Would be in its own repo

{
  # # Add additional subflakes as needed
  inputs.tracelinks.url = "path:./tracelinks";
  inputs.tracelinks.inputs.capacitor.follows = "capacitor";

  inputs.flox.url = "github:flox/flox/minicapacitor";
  inputs.flox.inputs.capacitor.follows = "capacitor";

  inputs.catalog.url = "path:./catalog";
  inputs.catalog.inputs.capacitor.follows = "capacitor";

  outputs = {capacitor, ...} @ args : capacitor args ({has,...}:
    
    has.projectsFromInputs

    (has.localPackages ./path)
    {}
   
  );

}
