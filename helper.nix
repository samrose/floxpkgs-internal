self: capacitor: inputs: rec {
  call = import ./call-flake.nix;
  lock = builtins.fromJSON (builtins.readFile (self + "/flake.lock"));
  subflake = k: extras: overrides:
    call (builtins.readFile (self + "/flake.lock")) self "" "pkgs/${k}" "${k}" extras (
      if overrides ? inputs
      then follow overrides
      else overrides
    );
  subflakes = with capacitor.lib; builtins.attrNames (filterAttrs (key: v: hasPrefix "path:./" v.url) inputs);

  callSubflake = sub: subflake sub {capacitor = ["capacitor"];};

  callSubflakeWith = sub: overrides: let
    outputs = subflake sub {capacitor = ["capacitor"];} overrides;
  in
    outputs;

  callSubflakesWith = subflakes: overrides:
    capacitor.lib.genAttrs subflakes (sub: let
      outputs = callSubflakeWith sub overrides;
    in
      outputs);

  follow = overrides: let
    r = path: l: o:
      with capacitor.lib;
        mapAttrsRecursiveList (_: a: !builtins.isString a)
        (path: value:
          assert (capacitor.lib.last path == "follows"); {
            path = with builtins;
              filter isString (capacitor.lib.lists.imap0 (i: a:
                if i / 2 * 2 == i
                then a
                else [])
              path);
            follows = follows value;
          })
        o;
    val = capacitor.lib.flatten (r [] lock.nodes overrides.inputs);
  in
    val;
  callSubflakes = callSubflakesWith subflakes;
  follows = capacitor.lib.strings.splitString "/";

  /*
   Remove levels from attrset
   Adapted from std
   */

  autoSubflakes = callSubflakes {
    inputs.capacitor.inputs.nixpkgs.follows = "capacitor/nixpkgs/nixpkgs-unstable";
  };
  autoSubflakesWith = override:
    callSubflakes {
      inputs.capacitor.inputs.nixpkgs.follows = override;
    };

  mapRoot = builtins.mapAttrs (key: value:
    if capacitor.lib.elem key ["legacyPackages" "packages" "devShells" "checks" "apps" "bundlers" ]
    # hydraJobs are backward, nixosConfigurations need system differently
    then capacitor.lib.genAttrs ["x86_64-linux" "aarch64-linux"] (s: merge value [key s])
    else value);

  # perform multiple sanitize actions
  # remove multiple attribute names from a level of attrset
  # TODO: perform all at once in sanitize
  merge = value: builtins.foldl' (acc: x: sanitize acc x) value;

  # sanitize: attrset -> string -> attrset
  # remove an attribute name from a level of attrset
  sanitize = let
    lib = capacitor.lib;
    recurse = depth: fragment: system:
      if depth <= 0
      then fragment
      else
        {
          "derivation" = fragment;
          "lambda" = arg: recurse depth (fragment arg) system;
          "list" = map (x: recurse (depth - 1) x system) fragment;
          "set" =
            if fragment ? ${system}
            then recurse depth fragment.${system} system
            else lib.mapAttrs (_: fragment: recurse (depth - 1) fragment system) fragment;
          __functor = self: type: (self.${type} or fragment);
        } (lib.smartType fragment);
  in
    recurse 6;
}
