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
        sha256 = "c4d63dc38d6bbd0af2bf8e8bb3af5626c81d19e23d134bf87c85e16e4fa9adba",
        strip_prefix = "bazel-starlib-0.12.0",
        urls = [
            "http://github.com/cgrindel/bazel-starlib/archive/v0.12.0.tar.gz",
        ],
    )
