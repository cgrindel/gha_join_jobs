"""Dependencies for gha_join_jobs."""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def gha_join_jobs_dependencies():
    """Loads the dependencies for gha_join_jobs."""
    maybe(
        http_archive,
        name = "bazel_skylib",
        urls = [
            "https://github.com/bazelbuild/bazel-skylib/releases/download/1.4.2/bazel-skylib-1.4.2.tar.gz",
            "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.4.2/bazel-skylib-1.4.2.tar.gz",
        ],
        sha256 = "66ffd9315665bfaafc96b52278f57c7e2dd09f5ede279ea6d39b2be471e7e3aa",
    )

    http_archive(
        name = "cgrindel_bazel_starlib",
        sha256 = "00c5a281d5b9af70aeefb599d9daa77ea87c5f81c7233dcddd2934e3b641ab2c",
        strip_prefix = "bazel-starlib-0.17.0",
        urls = [
            "http://github.com/cgrindel/bazel-starlib/archive/v0.17.0.tar.gz",
        ],
    )
