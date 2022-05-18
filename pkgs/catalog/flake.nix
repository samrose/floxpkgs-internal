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
          vendorSha256 = "sha256-ma0WKBCvnAS6UsPpDHJ2dpmx6UP4G9ng16It/q/A9As=";
        });
}
