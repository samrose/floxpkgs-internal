{ lib, stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "mkdocs-macros-test";
  version = "0.1.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit version;
    inherit pname;
    sha256 = "1w12skm8l0r2x6z1va996lvq6z1873d0xzql9n0aja0g0v6s7ay5";
  };

  meta = with lib; {
    description = "A test pluglet for mkdocs-macros";
    maintainers = teams.deshaw.members;
    homepage = "https://github.com/fralau/mkdocs-macros-test";
  };
}
