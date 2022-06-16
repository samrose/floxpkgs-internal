{
  verify_installed = ''
    # TODO finish these criteria and make sure they're all tested
    # installed means:
    #   scriptlets ensure:
    #   - the installer closure is in the /nix/store and added to the nix database
    #   - systemd units are enabled and nix-daemon.socket is started
    #   - there is a zero length file at /usr/share/nix/nix.tar.xz
    #   - users and groups are added
    #   - selinux policy is loaded
    #   - TODO verify this: channels are set up
    #   - TODO anything else in the tarball from /nix?
    #   the package manager tracks all of the following files:
    #   - there is a gcroot for each derivation used to create the closure in FLOX_GCROOT, and there are no additional gcroots in FLOX_GCROOT
    #   - binaries are linked in /usr/bin and /usr/sbin
    #   - man pages are linked in /usr/share
    #   - files from the rootfs directory
    #   - systemd unit files
    #   - various other files: flox.toml, repo files, nix-daemon.conf, flox-version
    #
    # State machine:
    # uninstalled -install_1-> installed_1
    # installed_1 -uninstall_1-> uninstalled
    #             -upgrade-> installed_2
    # TODO add transitions for installed_2
    # if we run install, uninstall, install, upgrade, and uninstall we'll hit a good chunk of this

    systemctl status nix-daemon.socket
    # nix-daemon.service must be started by the socket otherwise permissions won't be correct
    systemctl status nix-daemon.service && exit 1
    sudo nix-collect-garbage -d
    # uncomment after this doesn't run through interactive flox setup
    #[[ $(flox --version) =~ "Version: "[0-9]\.[0-9]\.[0-9] ]]
    man flox > /dev/null
    # nix can do something non-trivial. This is kinda slow because it pulls nixpkgs...
    [[ $(nix run nixpkgs#hello) == "Hello, world!" ]]
    man nix > /dev/null
    systemctl status nix-daemon.socket
    systemctl status nix-daemon.service
    test -f /etc/systemd/system/sockets.target.wants/nix-daemon.socket
    test -f /etc/systemd/system/multi-user.target.wants/nix-daemon.service
  '';
  verify_uninstalled = ''
    # uninstalled means (for now focus on things scriptlets do, since they're more likely to have mistakes):
    #   - /nix does not exist
    #   - systemd units are disabled
    test -d /nix && exit 1
    systemctl status nix-daemon.socket && exit 1
    systemctl status nix-daemon.service && exit 1
    test -f /etc/systemd/system/sockets.target.wants/nix-daemon.socket && exit 1
    test -f /etc/systemd/system/multi-user.target.wants/nix-daemon.service && exit 1
    grep nixbld /etc/passwd && exit 1
    getent group nixbld && exit 1
    test -f /usr/bin/nix && exit 1
  '';
}