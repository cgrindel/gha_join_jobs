"""Dependencies for gha_join_jobs."""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def gha_join_jobs_dependencies():
    """Loads the dependencies for gha_join_jobs."""
    maybe(
        http_archive,
        name = "bazel_skylib",
        urls = [
            "https://github.com/bazelbuild/bazel-skylib/releases/download/1.4.0/bazel-skylib-1.4.0.tar.gz",
            "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.4.0/bazel-skylib-1.4.0.tar.gz",
        ],
        sha256 = "f24ab666394232f834f74d19e2ff142b0af17466ea0c69a3f4c276ee75f6efce",
    )

    http_archive(
        name = "cgrindel_bazel_starlib",
        sha256 = "8865c291abf5f4f7b979ab4898906209516737fc33e370c3daa562ba4445f48d",
        strip_prefix = "bazel-starlib-0.12.1",
        urls = [
            "http://github.com/cgrindel/bazel-starlib/archive/v0.12.1.tar.gz",
        ],
    )
