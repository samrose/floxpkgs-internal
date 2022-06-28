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
                "compute_engine_instance": {
                    "image_project": "cirrus-images",
                }
            },
            instructions=[script(bootstrap_deb()),
               script("flox run .#test-deb")]
        ),
    ]
