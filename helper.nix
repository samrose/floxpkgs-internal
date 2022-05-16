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
  #if outputs?default && builtins.length (builtins.attrNames outputs) == 1 then outputs.default else outputs;

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
  sanitize = let
    lib = capacitor.lib;
    recurse = depth: fragment: system:
      if depth <= 0
      then fragment
      else
        {
          "derivation" = fragment;
          "lambda" = recurse depth (fragment system) system;
          "list" = map (x: recurse (depth - 1) x system) fragment;
          "set" =
            if fragment ? ${system}
            then recurse depth fragment.${system} system
            else lib.mapAttrs (_: fragment: recurse (depth - 1) fragment system) fragment;
          __functor = self: type: ( self.${type} or fragment);
        } (lib.smartType fragment);
  in
    recurse 6;
}
