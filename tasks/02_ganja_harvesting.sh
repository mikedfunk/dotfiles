#!/usr/bin/env bash

function ganja_harvesting_init() {
  task_setup "ganja_harvesting" "Harvesting" "Harvest the ganja plants" "ganja_seeding ganja_farming"
}

function ganja_harvesting_run() {
  log_info "Cutting the plants..."

  if [ -f "scissors" ]; then
    echo "bigbuds" >> ./ganja_crop
    return ${E_SUCCESS}
  else
    log_error "Missing scissors. Please touch the scissors."
    return ${E_FAILURE}
  fi
}
