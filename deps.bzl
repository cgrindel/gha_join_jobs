"""Dependencies for gha_join_jobs."""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def gha_join_jobs_dependencies():
    """Loads the dependencies for gha_join_jobs."""
    maybe(
        http_archive,
        name = "bazel_skylib",
        urls = [
            "https://github.com/bazelbuild/bazel-skylib/releases/download/1.7.0/bazel-skylib-1.7.0.tar.gz",
            "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.7.0/bazel-skylib-1.7.0.tar.gz",
        ],
        sha256 = "d00f1389ee20b60018e92644e0948e16e350a7707219e7a390fb0a99b6ec9262",
    )

    http_archive(
        name = "cgrindel_bazel_starlib",
        sha256 = "b05401644174f70467ee7ea823ea9e8033080bc5612c0bcc319a670fd43e5f32",
        strip_prefix = "bazel-starlib-0.20.2",
        urls = [
            "http://github.com/cgrindel/bazel-starlib/archive/v0.20.2.tar.gz",
        ],
    )
