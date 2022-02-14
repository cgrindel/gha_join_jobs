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

fail_sh_location=cgrindel_bazel_starlib/shlib/lib/fail.sh
fail_sh="$(rlocation "${fail_sh_location}")" || \
  (echo >&2 "Failed to locate ${fail_sh_location}" && exit 1)
source "${fail_sh}"

env_sh_location=cgrindel_bazel_starlib/shlib/lib/env.sh
env_sh="$(rlocation "${env_sh_location}")" || \
  (echo >&2 "Failed to locate ${env_sh_location}" && exit 1)
source "${env_sh}"

gh_actions_api_jq_sh_location=cgrindel_gha_join_jobs/libs/gh_actions_api_jq.sh
gh_actions_api_jq_sh="$(rlocation "${gh_actions_api_jq_sh_location}")" || \
  (echo >&2 "Failed to locate ${gh_actions_api_jq_sh_location}" && exit 1)
source "${gh_actions_api_jq_sh}"


# MARK - Check for required software

is_installed jq || fail "Could not find jq for JSON parsing."


# MARK - Process Args

# We are expecting to be run in a GitHub Actions workflow
github_repository="${GITHUB_REPOSITORY:-}"
github_run_id="${GITHUB_RUN_ID:-}"
github_run_attempt="${GITHUB_RUN_ATTEMPT:-}"
github_job="${GITHUB_JOB:-}"

args=()
while (("$#")); do
  case "${1}" in
    "--job_names")
      job_names="${2}"
      shift 2
      ;;
    *)
      args+=("${1}")
      shift 1
      ;;
  esac
done

[[ -z "${github_repository:-}" ]] && fail "Expected a value for github_repository."
[[ -z "${github_run_id:-}" ]] && fail "Expected a value for github_run_id."
[[ -z "${github_run_attempt:-}" ]] && fail "Expected a value for github_run_attempt."
[[ -z "${github_job:-}" ]] && fail "Expected a value for github_job."

# MARK - Check Jobs

# Retrieve the jobs for the current run.
jobs_json="$( 
  gh api "/repos/${github_repository}/actions/runs/${github_run_id}/attempts/${github_run_attempt}/jobs" 
)"

# Retrieve the jobs of interest.
filter_jobs_cmd=( get_filtered_jobs_json --current_job "${github_job}" --job_json "${jobs_json}" )
[[ -n "${job_names:-}" ]] && filter_jobs_cmd+=( --job_names "${job_names}" )
filtered_jobs_json="$( "${filter_jobs_cmd[@]}" )"

# Be sure that all of the other jobs have a conclusion of 'success'.
# If so, exit.
all_jobs_concluded_with "success" "${filtered_jobs_json}" && exit

# Extract the jobs that did not succeed
unsuccessful_jobs="$( get_unsuccessful_jobs_summary "${filtered_jobs_json}" )"
echo >&2 "Unsuccessful jobs:"$'\n'"${unsuccessful_jobs}"
exit 1
