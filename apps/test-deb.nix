{ writeShellApplication, lib, getent, gnugrep, ... }: {
  type = "app";
  program = (writeShellApplication {
    name = "test-deb";
    runtimeInputs = [ getent gnugrep ];
    text = let
      verify_installed_ubuntu = ''
        ${lib.test-installer.verify_installed}
      '';
    in ''
      set -euxo pipefail
      verify_installed() {
        ${lib.test-installer.verify_installed}
        sudo apt-get update -o Dir::Etc::sourcelist="/etc/apt/sources.list.d/flox.list" -o Dir::Etc::sourceparts="-"
      }
      verify_uninstalled() {
        ${lib.test-installer.verify_uninstalled}
      }
      verify_installed
      floxPath1=$(readlink /usr/bin/flox)
      sudo dpkg --purge flox
      verify_uninstalled
      sudo dpkg --install flox.deb
      verify_installed
      sudo dpkg --install flox2.deb
      [[ $floxPath1 != $(readlink /usr/bin/flox) ]]
      verify_installed
      sudo dpkg --purge flox
      verify_uninstalled
      exit 0
    '';
  }) + "/bin/test-deb";
}
