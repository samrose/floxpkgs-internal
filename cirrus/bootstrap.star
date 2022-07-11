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
        flox --version
        mkdir -p myproj && cd myproj
        curl -O https://raw.githubusercontent.com/flox/floxpkgs/master/test/flox-init-dev-env.exp
        curl -O https://raw.githubusercontent.com/flox/floxpkgs/master/test/dev-env.exp
        curl -O https://raw.githubusercontent.com/flox/floxpkgs/master/test/dev-env.bats
        expect flox-init-dev-env.exp
        expect dev-env.exp
    """

def bootstrap_deb():
    return """
        su - ubuntu -c 'sudo apt update'
        su - ubuntu -c 'sudo apt install -y expect bats'
        su - ubuntu  -c  'curl -f -u floxfan:himom https://alpha.floxsdlc.com/downloads/debian-archive/flox.deb -o flox.deb'
         su - ubuntu  -c 'sudo dpkg -i flox.deb'
         su - ubuntu  -c 'flox --version'
         su - ubuntu  -c 'mkdir -p myproj && cd myproj'
         su - ubuntu  -c 'curl -O https://raw.githubusercontent.com/flox/floxpkgs/master/test/flox-init-dev-env.exp'
         su - ubuntu  -c 'curl -O https://raw.githubusercontent.com/flox/floxpkgs/master/test/dev-env.exp'
         su - ubuntu  -c 'curl -O https://raw.githubusercontent.com/flox/floxpkgs/master/test/dev-env.bats'
         su - ubuntu  -c 'expect flox-init-dev-env.exp'
         su - ubuntu  -c 'expect dev-env.exp'
    """
