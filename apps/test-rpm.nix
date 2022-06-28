{ writeShellApplication, lib, getent, gnugrep, ... }: {
  type = "app";
  program = (writeShellApplication {
    name = "test-rpm";
    runtimeInputs = [ getent gnugrep ];
    text = ''
      set -euxo pipefail
      verify_installed() {
        ${lib.test-installer.verify_installed}
        sudo semodule --list | grep nix > /dev/null
        dnf search flox --repo flox | grep "Exactly Matched"
        sudo dnf update flox --repo flox
      }
      verify_uninstalled() {
        ${lib.test-installer.verify_uninstalled}
        sudo semodule --list | grep nix && exit 1
        dnf repolist --repo flox && exit 1
      }
      verify_installed
      floxPath1=$(readlink /usr/bin/flox)
      sudo rpm --erase flox
      verify_uninstalled
      sudo rpm -i flox.rpm
      verify_installed
      sudo rpm -U flox2.rpm
      [[ $floxPath1 != $(readlink /usr/bin/flox) ]]
      verify_installed
      sudo rpm --erase flox
      verify_uninstalled
      exit 0
    '';
  }) + "/bin/test-rpm";
}
