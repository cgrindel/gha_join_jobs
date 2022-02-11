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
      "--job")
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
      *)
        args+=("${1}")
        shift 1
        ;;
    esac
  done

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
