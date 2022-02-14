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

jobs_json_location=cgrindel_gha_join_jobs/tests/gh_actions_api_jq_tests/jobs.json
jobs_json_path="$(rlocation "${jobs_json_location}")" || \
  (echo >&2 "Failed to locate ${jobs_json_location}" && exit 1)


# MARK - Test

jobs_json="$(< "${jobs_json_path}")"

results="$(
  get_filtered_jobs_json \
    --current_job all_tests \
    --jobs_json "${jobs_json}" 
)"
count=$(echo "${results}" | jq -r 'length')
assert_equal 2 ${count} "Expected jobs count without job_names."
actual_job_names="$( echo "${results}" | jq -c 'map(.name) | sort' )"
assert_equal '["job1","job2"]' "${actual_job_names}" "Expected job names without job_names."

results="$(
  get_filtered_jobs_json \
    --current_job all_tests \
    --jobs_json "${jobs_json}" \
    --job_names '["job2"]'
)"
count=$(echo "${results}" | jq -r 'length')
assert_equal 1 ${count} "Expected jobs count with job_names."
actual_job_names="$( echo "${results}" | jq -c 'map(.name) | sort' )"
assert_equal '["job2"]' "${actual_job_names}" "Expected job names with job_names."
