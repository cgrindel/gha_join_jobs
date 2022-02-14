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

# MARK - Test

jobs_json='[{"conclusion":"success"},{"conclusion":"success"}]'
all_jobs_concluded_with "success" "${jobs_json}" || fail "Expected all to be success."

jobs_json='[{"conclusion":"cancelled"},{"conclusion":"cancelled"}]'
all_jobs_concluded_with "cancelled" "${jobs_json}" || fail "Expected all to be cancelled."

jobs_json='[{"conclusion":"success"},{"conclusion":"cancelled"}]'
all_jobs_concluded_with "success" "${jobs_json}" && fail "Expected failure."

jobs_json='[{"conclusion":"cancelled"},{"conclusion":"success"}]'
all_jobs_concluded_with "success" "${jobs_json}" && fail "Expected failure."

# End on something pleasant
echo "All is well."
