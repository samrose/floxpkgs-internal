{
  # Src input declarations
  inputs.src.url = "git+ssh://git@github.com/flox/tracelinks?ref=main";
  inputs.src.flake = false;

  # Example of pinnig to a specific nixpkgs
  inputs.nixpkgs-stable.url = "github:flox/nixpkgs/d236aeb87f660cb2945dad63bcfdd2540eda1b53";

  outputs = _: _.capacitor _ ({
      self,
      auto,
      ...
    }: {
      # Public exported variants
      packages = {
        default = auto.callPackage self.__proto.default {};
        special = auto.callPackage self.__proto.default {argument = "-special";};

        # Example pinning to specific nixpkgs
        pinned = {system, ...}:
          auto.callPackage self.__proto.default {
            argument = "-pinned";
          }
          self.inputs.nixpkgs-stable.legacyPackages.${system};
      };

      # Public exported variants to join into namespace
      legacyPackages = self.packages;

      # Proto-derivation to re-use definition
      __proto.default = {
        stdenv,
        help2man,
        src,
        argument ? "",
        ...
      }:
        stdenv.mkDerivation {
          pname = "tracelinks${argument}";
          version = "1.0.0+r${toString src.revCount}";
          inherit src;

          # Prevent the source from becoming a runtime dependeny
          disallowedReferences = [src.outPath];
          nativeBuildInputs = [help2man];
          makeFlags = ["PREFIX=$(out)"];
        };
    });
}
