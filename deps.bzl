"""Dependencies for gha_join_jobs."""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def gha_join_jobs_dependencies():
    """Loads the dependencies for gha_join_jobs."""
    maybe(
        http_archive,
        name = "bazel_skylib",
        urls = [
            "https://github.com/bazelbuild/bazel-skylib/releases/download/1.4.1/bazel-skylib-1.4.1.tar.gz",
            "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.4.1/bazel-skylib-1.4.1.tar.gz",
        ],
        sha256 = "b8a1527901774180afc798aeb28c4634bdccf19c4d98e7bdd1ce79d1fe9aaad7",
    )

    http_archive(
        name = "cgrindel_bazel_starlib",
        sha256 = "df971d4736cf30ab5332536715eeb00c1a67ca6440610e8bc3b73a35aaff34dc",
        strip_prefix = "bazel-starlib-0.16.0",
        urls = [
            "http://github.com/cgrindel/bazel-starlib/archive/v0.16.0.tar.gz",
        ],
    )
