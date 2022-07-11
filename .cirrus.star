load("github.com/cirrus-modules/helpers", "task", "macos_instance", "script")
load("cirrus/bootstrap.star", "bootstrap_macos", "bootstrap_deb")

def main(ctx):
    return [
        task(
            "test_bootstrap_macos",
            instance=macos_instance("ghcr.io/cirruslabs/macos-monterey-base:latest"),
            instructions=[script(bootstrap_macos())]
        ),
        task(
            "test_install_ubuntu",
            instance= {
                "ec2_instance": {
                    "image": "ami-08d4ac5b634553e16",
		    "type": "t2.micro",
		    "region": "us-east-1"
                }
            },
            instructions=[script(bootstrap_deb())]
        ),
    ]
