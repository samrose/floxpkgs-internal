{ lib
, python2Packages
, fetchFrom
, inputs
}:

let
  pythonPackages = python2Packages;

in
pythonPackages.buildPythonApplication rec {
  src = fetchFrom inputs "git+ssh://git@github.com/flox/mini-dinstall?ref=main";
  name = "mini-dinstall";
  version = "0.6.28.1";

  # The source for this project was pulled from github for some
  # reason so we're restoring it from the copy in /nix/store.
  # version = "0.6.28.1"; # As originally obtained from:
  # src = fetchFromGitHub {
  #   owner = "shartge";
  #   repo = pname;
  #   rev = "a490b9e";
  #   sha256 = "0knbqall0qvddgqwwwcw3fj0asdkmalp286zh7j2cc76x0xjkgsx";
  # };

  propagatedBuildInputs = with pythonPackages; [ python-apt ];

  # Set environment variable to trick `apt` package into believing
  # we're running this on a Debian system.
  makeWrapperArgs = [ "--set DEBIAN_SYSTEM 1" ];

  meta = with lib; {
    description = "Daemon for updating Debian packages in a repository";
    homepage = "https://github.com/shartge/mini-dinstall";
    license = licenses.gpl2;
    maintainers = with maintainers; [ limeytexan ];
    platforms = platforms.all;
  };
}
