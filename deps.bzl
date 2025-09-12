"""Dependencies for gha_join_jobs."""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def gha_join_jobs_dependencies():
    """Loads the dependencies for gha_join_jobs."""
    maybe(
        http_archive,
        name = "bazel_skylib",
        urls = [
            "https://github.com/bazelbuild/bazel-skylib/releases/download/1.8.1/bazel-skylib-1.8.1.tar.gz",
            "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.8.1/bazel-skylib-1.8.1.tar.gz",
        ],
        sha256 = "51b5105a760b353773f904d2bbc5e664d0987fbaf22265164de65d43e910d8ac",
    )

    http_archive(
        name = "cgrindel_bazel_starlib",
        sha256 = "931278ff3fac323412dbc6ebd0846010394647f20b285b9d771ba3c92c3e13ae",
        strip_prefix = "bazel-starlib-0.22.0",
        urls = [
            "http://github.com/cgrindel/bazel-starlib/archive/v0.22.0.tar.gz",
        ],
    )
