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
       sudo -H -u ubuntu bash -c  "curl -f -u floxfan:himom https://alpha.floxsdlc.com/downloads/debian-archive/flox.deb -o flox.deb"
        sudo -H -u ubuntu bash -c "sudo dpkg -i flox.deb"
	sudo -H -u ubuntu bash -c "flox build .#nix-installers/deb"
        sudo -H -u ubuntu bash -c "sudo dpkg -r flox.deb"
        sudo -H -u ubuntu bash -c "sudo dpkg -i result"
    """
