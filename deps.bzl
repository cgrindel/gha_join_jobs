"""Dependencies for gha_join_jobs."""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def gha_join_jobs_dependencies():
    """Loads the dependencies for gha_join_jobs."""
    maybe(
        http_archive,
        name = "bazel_skylib",
        urls = [
            "https://github.com/bazelbuild/bazel-skylib/releases/download/1.5.0/bazel-skylib-1.5.0.tar.gz",
            "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.5.0/bazel-skylib-1.5.0.tar.gz",
        ],
        sha256 = "cd55a062e763b9349921f0f5db8c3933288dc8ba4f76dd9416aac68acee3cb94",
    )

    http_archive(
        name = "cgrindel_bazel_starlib",
        sha256 = "b05401644174f70467ee7ea823ea9e8033080bc5612c0bcc319a670fd43e5f32",
        strip_prefix = "bazel-starlib-0.20.2",
        urls = [
            "http://github.com/cgrindel/bazel-starlib/archive/v0.20.2.tar.gz",
        ],
    )
