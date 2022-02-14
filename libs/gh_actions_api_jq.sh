#!/usr/bin/env bash

is_item_in_json_array() {
  local item="${1}"
  local list_json="${2}"
  contains_item="$(
    jq -n \
      --argjson list "${list_json}" \
      --arg item "${item}" \
      '$item | IN($list[])'
  )"
  [[ "${contains_item}" == true ]] && return
  return 1
}

get_filtered_jobs_json() {
  local args=()
  while (("$#")); do
    case "${1}" in
      "--current_job")
        local current_job="${2}"
        shift 2
        ;;
      "--jobs_json")
        local jobs_json="${2}"
        shift 2
        ;;
      "--job_names")
        local job_names="${2}"
        shift 2
        ;;
      *--)
        echo >&2 "Unrecognized flag. ${1}"
        return 1
        ;;
      *)
        args+=("${1}")
        shift 1
        ;;
    esac
  done

  [[ -z "${current_job:-}" ]] && echo >&2 "Expected a value for current_job." && return 1
  [[ -z "${jobs_json:-}" ]] && echo >&2 "Expected a value for jobs_json." && return 1 

  local jq_cmd=( jq )
  local jq_src='.jobs | map(select(.name != "'"${current_job}"'"))'
  if [[ -n "${job_names:-}" ]]; then
    # Ensure that job names does not contain our JOB name
    is_item_in_json_array "${current_job}" "${job_names}" && \
      echo >&2 "This job name (${current_job}) is included in your jobs list." && \
      return 1

    jq_src+=' | map(select(.name | IN($job_names[])))'
    jq_cmd+=( --argjson job_names "${job_names}" )
  fi
  jq_cmd+=( "${jq_src}" )
  echo "${jobs_json}" | "${jq_cmd[@]}"
}

all_jobs_concluded_with() {
  local status="${1}"
  local jobs_array_json="${2}"

  local conclusion_check="$(
    echo "${jobs_array_json}" | jq 'all(.conclusion == "'"${status}"'")'
  )"

  # If all are the same conclusion, then return success
  [[ "${conclusion_check}" == true ]] && return

  # Otherwise, return failure
  return 1
}

get_unsuccessful_jobs_summary() {
  local jobs_array_json="${1}"
  echo "${jobs_array_json}" | \
    jq 'map(select(.conclusion != "success")) | map({id, name, status, conclusion})'
}
