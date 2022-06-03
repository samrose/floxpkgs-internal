{
  inputs.src.url = "git+ssh://git@github.com/flox/tracelinks?ref=main";
  inputs.src.flake = false;

  outputs = { capacitor, ... } @ args:
    capacitor args ({auto,...}: {
      #
      # copy proto-derivation here
      #
      packages =
        auto.callPackage ({ 
          stdenv
        , help2man
        , src
        , argument ? ""
        , withRev
        }:
        stdenv.mkDerivation {
          inherit src;
          pname = "tracelinks${argument}";
          version = withRev "1.0.0";

          # Prevent the source from becoming a runtime dependeny
          disallowedReferences = [ src.outPath ];
          nativeBuildInputs = [ help2man ];
          makeFlags = [ "PREFIX=$(out)" ];
        }) {};
    });
}
