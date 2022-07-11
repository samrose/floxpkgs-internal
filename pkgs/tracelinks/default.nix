{ stdenv
, help2man
, inputs
, argument ? ""
, withRev
}:
stdenv.mkDerivation {
  src = inputs."flox/tracelinks";
  pname = "tracelinks${argument}";
  version = withRev "1.0.0";

  # Prevent the source from becoming a runtime dependeny
  disallowedReferences = [ inputs."flox/tracelinks".outPath ];
  nativeBuildInputs = [ help2man ];
  makeFlags = [ "PREFIX=$(out)" ];
}
