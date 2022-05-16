rec {
  inputs.capacitor.url = "git+ssh://git@github.com/flox/capacitor?ref=ysndr";
  inputs.capacitor.inputs.root.follows = "/";

  inputs.tracelinks.url = "path:./pkgs/tracelinks";

  outputs = _: 
  # boilerplate {{{
  let
    inherit (import ./helper.nix _.self _.capacitor inputs) autoSubflakesWith mapRoot callSubflakeWith merge;
  in
  mapRoot (_.capacitor _ ({self,capacitor,auto,...}:
    # }}}
  {
    __systems = ["x86_64-linux"];
    legacyPackages = {pkgs,...}: {
      nixpkgs = capacitor.inputs.nixpkgs;
      flox = capacitor.lib.genAttrs [ "stable" "staging" "unstable"] (stability:
        # support flakes approach
        autoSubflakesWith "capacitor/nixpkgs/nixpkgs-${stability}"
        //
        # support default.nix approach
        auto.automaticPkgs ./pkgs pkgs.${stability}
      );
    };
  }));

  # API calls
  inputs.cached__nixpkgs-stable__x86_64-linux.url = "https://hydra.floxsdlc.com/channels/nixpkgs/stable/x86_64-linux.tar.gz";
}
