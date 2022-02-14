#!/usr/bin/env bash

# --- begin runfiles.bash initialization v2 ---
# Copy-pasted from the Bazel Bash runfiles library v2.
set -uo pipefail; f=bazel_tools/tools/bash/runfiles/runfiles.bash
source "${RUNFILES_DIR:-/dev/null}/$f" 2>/dev/null || \
  source "$(grep -sm1 "^$f " "${RUNFILES_MANIFEST_FILE:-/dev/null}" | cut -f2- -d' ')" 2>/dev/null || \
  source "$0.runfiles/$f" 2>/dev/null || \
  source "$(grep -sm1 "^$f " "$0.runfiles_manifest" | cut -f2- -d' ')" 2>/dev/null || \
  source "$(grep -sm1 "^$f " "$0.exe.runfiles_manifest" | cut -f2- -d' ')" 2>/dev/null || \
  { echo>&2 "ERROR: cannot find $f"; exit 1; }; f=; set -e
# --- end runfiles.bash initialization v2 ---


# MARK - Locate Deps

assertions_sh_location=cgrindel_bazel_starlib/shlib/lib/assertions.sh
assertions_sh="$(rlocation "${assertions_sh_location}")" || \
  (echo >&2 "Failed to locate ${assertions_sh_location}" && exit 1)
source "${assertions_sh}"

gh_actions_api_jq_sh_location=cgrindel_gha_join_jobs/libs/gh_actions_api_jq.sh
gh_actions_api_jq_sh="$(rlocation "${gh_actions_api_jq_sh_location}")" || \
  (echo >&2 "Failed to locate ${gh_actions_api_jq_sh_location}" && exit 1)
source "${gh_actions_api_jq_sh}"


# MARK - Test that unsuccessful are returned

jobs_json='[
  {"id":"1001","name":"job1","status":"in_progress","conclusion":null},
  {"id":"1002","name":"job2","status":"completed","conclusion":"success"},
  {"id":"1003","name":"job3","status":"completed","conclusion":"failed"}
]'
expected='[
  {"id":"1001","name":"job1","status":"in_progress","conclusion":null},
  {"id":"1003","name":"job3","status":"completed","conclusion":"failed"}
]'
# Let jq format the expected value so that it will match.
expected="$( echo "${expected}" | jq '.' )"
actual="$( get_unsuccessful_jobs_summary "${jobs_json}" )"
assert_equal "${expected}" "${actual}" "Expected one result."


# MARK - Test that unsuccessful are returned

jobs_json='[
  {"id":"1002","name":"job2","status":"completed","conclusion":"success"}
]'
expected='[]'
# Let jq format the expected value so that it will match.
expected="$( echo "${expected}" | jq '.' )"
actual="$( get_unsuccessful_jobs_summary "${jobs_json}" )"
assert_equal "${expected}" "${actual}" "Expected no results."
