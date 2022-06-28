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
        su - ubuntu  -c  "curl -f -u floxfan:himom https://alpha.floxsdlc.com/downloads/debian-archive/flox.deb -o flox.deb"
        su - ubuntu  -c "sudo dpkg -i flox.deb"
        su - ubuntu  -c "mkdir -p /home/ubuntu/.config/gh"
        su - ubuntu  -c "echo $GH >  /home/ubuntu/.config/gh/hosts.yml"
        su - ubuntu  -c "flox build .#nix-installers/deb"
        su - ubuntu  -c "sudo dpkg -r flox.deb"
        su - ubuntu  -c "sudo dpkg -i result"
    """
