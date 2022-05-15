{
  # Private input declarations
  inputs.src.url = "git+ssh://git@github.com/flox/tracelinks?ref=main";
  inputs.src.flake = false;

  outputs = inputs:
    inputs.capacitor inputs ({ self, auto, ...  }: {

      # Public exported derivations
      packages.default = auto.callProto self.__proto.default {};
      packages.special = auto.callProto self.__proto.default {argument="-special";};

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
