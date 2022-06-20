def bootstrap_macos():
    return """
        sh <(curl -L https://nixos.org/nix/install) --daemon
        # we want nix in $PATH
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
        sudo -H nix --extra-experimental-features 'flakes nix-command' profile install --profile /nix/var/nix/profiles/default nixpkgs#git nixpkgs#openssh
        eval $(ssh-agent)
        ssh-add - <<< "${FLOXBOT_KEY}"
        # nix won't accept new keys by default
        sudo -H ssh git@github.com -o StrictHostKeyChecking=accept-new || true
        sudo -H nix --extra-experimental-features 'flakes nix-command' profile install --profile /nix/var/nix/profiles/default 'git+ssh://git@github.com/flox/flox?ref=tng'
    """

def bootstrap_deb():
    return """
        flox build .#nix-installers/deb
        sudo dpkg -i result
    """