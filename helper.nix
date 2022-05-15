self: capacitor: inputs: rec {
    call = import ./call-flake.nix;
    lock = builtins.fromJSON (builtins.readFile ./flake.lock);
    subflake = k: call (builtins.readFile ./flake.lock) self "" "pkgs/${k}" "${k}";
    subflakes = with capacitor.lib; builtins.attrNames (filterAttrs (key: v: hasPrefix "path:./" v.url) inputs);
    callSubflakeWith = pkgs: sub: overrides:
    let o = if overrides?inputs
    then follow overrides
    else overrides;
    outputs = (subflake sub {capacitor=["capacitor"];} o).packages.${pkgs.system or pkgs.unstable.system};
    in if outputs?default && builtins.length (builtins.attrNames outputs) == 1 then outputs.default else outputs;

    callSubflakesWith = pkgs: subflakes: overrides: capacitor.lib.genAttrs subflakes (sub:
    let outputs = (callSubflakeWith pkgs sub overrides);
    in if outputs?default && builtins.length (builtins.attrNames outputs) == 1 then outputs.default else outputs);

    follow = overrides:
      let r = path: l: o:
      with capacitor.lib; mapAttrsRecursiveList (_: a: !builtins.isString a)
      (path: value: assert (capacitor.lib.last path == "follows"); {
        path= with builtins; filter isString (capacitor.lib.lists.imap0 (i: a: if i / 2 *2 == i then a else []) path);
        follows = follows value;} )
      o;
      val = (capacitor.lib.flatten (r [] lock.nodes overrides.inputs));
      in val;
    callSubflakes = pkgs: callSubflakesWith pkgs subflakes;
    follows = capacitor.lib.strings.splitString "/";
}
