{
  inputs.src.url = "git+ssh://git@github.com/flox/catalog?ref=master";
  inputs.src.flake = false;

  outputs = { capacitor, src, ... } @ args: capacitor args ({ auto, ... }: {

    packages =
      auto.callPackage ({ buildGoModule
      , inputs
      , withRev
      , ...
      }:
      buildGoModule rec {
        pname = "catalog";
        version = withRev "1.0.0";
        src = inputs.src;
        vendorSha256 = "sha256-3/7jk7SoxBndIoDmXToPwpYUffTXraQOAMzymPhsBZk=";
      }) {};
  });
}
