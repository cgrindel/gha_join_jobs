"""Dependencies for gha_join_jobs."""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def gha_join_jobs_dependencies():
    """Loads the dependencies for gha_join_jobs."""
    maybe(
        http_archive,
        name = "bazel_skylib",
        urls = [
            "https://github.com/bazelbuild/bazel-skylib/releases/download/1.3.0/bazel-skylib-1.3.0.tar.gz",
            "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.3.0/bazel-skylib-1.3.0.tar.gz",
        ],
        sha256 = "74d544d96f4a5bb630d465ca8bbcfe231e3594e5aae57e1edbf17a6eb3ca2506",
    )

    http_archive(
        name = "cgrindel_bazel_starlib",
        sha256 = "f10f9a47f23a76e6cc6f8af0b2d0c6377452e5b17ebeed6dbd656f0ba2aaa4ec",
        strip_prefix = "bazel-starlib-0.8.1",
        urls = [
            "http://github.com/cgrindel/bazel-starlib/archive/v0.8.1.tar.gz",
        ],
    )
