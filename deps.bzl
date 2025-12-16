"""Dependencies for gha_join_jobs."""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def gha_join_jobs_dependencies():
    """Loads the dependencies for gha_join_jobs."""
    maybe(
        http_archive,
        name = "bazel_skylib",
        urls = [
            "https://github.com/bazelbuild/bazel-skylib/releases/download/1.9.0/bazel-skylib-1.9.0.tar.gz",
            "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.9.0/bazel-skylib-1.9.0.tar.gz",
        ],
        sha256 = "3b5b49006181f5f8ff626ef8ddceaa95e9bb8ad294f7b5d7b11ea9f7ddaf8c59",
    )

    http_archive(
        name = "cgrindel_bazel_starlib",
        sha256 = "b97a9121843b9f51ddadc909eb9cfdc38c7f7892d707c1245a9a134e827abfb2",
        strip_prefix = "bazel-starlib-0.21.0",
        urls = [
            "http://github.com/cgrindel/bazel-starlib/archive/v0.21.0.tar.gz",
        ],
    )
