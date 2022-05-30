{
  inputs.src.url = "git+ssh://git@github.com/flox/catalog?ref=master";
  inputs.src.flake = false;

  outputs = { capacitor, src, ... } @ args: capacitor args ({ ... }: {

    packages =
      { buildGoModule
      , src
      , ...
      }:
      buildGoModule rec {
        pname = "catalog";
        version = "1.0.0-r${toString src.revCount}";
        inherit src;
        vendorSha256 = "sha256-3/7jk7SoxBndIoDmXToPwpYUffTXraQOAMzymPhsBZk=";
      };
  });
}
