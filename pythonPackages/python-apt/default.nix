{ lib
, stdenv
, buildPythonPackage
, pythonPackages
, fetchgit
, apt
, intltool
, zlib
}:

buildPythonPackage rec {
  pname = "python-apt";
  version = "2.1.3";

  src = fetchgit {
    url = "https://git.launchpad.net/python-apt";
    rev = version;
    sha256 = "1k5j3n04prxbvpdqi9nw2lg3vx24qdsh7z7szczh2m712v16gr0z";
  };

  nativeBuildInputs = [ intltool ];

  buildInputs = [ zlib ];

  # Unsurprisingly tests fail in sandbox with:
  # apt_pkg.Error: E:Unable to determine a suitable packaging system type
  doCheck = false;

  propagatedBuildInputs = [ apt pythonPackages.distutils_extra ];

  meta = with lib; {
    description = "apt_pkg";
    homepage = "https://pypi.python.org/pypi/python-apt";
    license = licenses.gpl2;
  };

}
