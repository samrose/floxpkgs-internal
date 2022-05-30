{
  inputs.src.url = "git+ssh://git@github.com/flox/tracelinks?ref=main";
  inputs.src.flake = false;

  outputs = { capacitor, ... } @ args:
    capacitor args (_: {
      #
      # copy proto-derivation here
      #
      packages =
        { stdenv
        , help2man
        , src
        , argument ? ""
        , ...
        }:
        stdenv.mkDerivation {
          inherit src;
          pname = "tracelinks${argument}";
          version = "1.0.0-r${toString src.revCount}";

          # Prevent the source from becoming a runtime dependeny
          disallowedReferences = [ src.outPath ];
          nativeBuildInputs = [ help2man ];
          makeFlags = [ "PREFIX=$(out)" ];
        };
    });
}
