load("github.com/cirrus-modules/helpers", "task", "macos_instance", "script")
load("cirrus/bootstrap.star", "bootstrap_macos")

def main(ctx):
    return [
        task(
            "test_bootstrap_macos",
            instance=macos_instance("ghcr.io/cirruslabs/macos-monterey-base:latest"),
            instructions=[script(bootstrap_macos())]
        ),
    ]