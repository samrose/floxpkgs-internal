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
          vendorSha256 = "sha256-h6y2Pj+JdbSNvC+bg0AA5Y1jmaZsC9kdORC2Fw4okv8=";
        });
}
