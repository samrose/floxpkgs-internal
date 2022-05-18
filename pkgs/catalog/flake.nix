{
  inputs.src.url = "git+ssh://git@github.com/flox/catalog?ref=master";
  inputs.src.flake = false;

  outputs = _:
    _.capacitor _ ({...}: {
        buildGoModule,
        src,
      } @ args:
        buildGoModule rec {
          pname = "catalog";
          version = "1.0.0-r${toString src.revCount}";
          inherit src;
          vendorSha256 = "sha256-RT6FnT2/lPp/qkYJgL8ExYkQMms+SOPeFPAOLG6yuUM=";
        });
}
