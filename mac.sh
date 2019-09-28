#!/bin/bash

set -e

command="mvn-switch"

SETTINGS_SYMLINK="/Users/$USER/.m2/settings.xml"
SETTINGS_WORK_FILE="settings-work.xml"
SETTINGS_TRAINING_FILE="settings-training.xml"

## Activities
TRAIN="train"
WORK="work"


#
# Early exit if no arguments are passed in
#
if [[ "${#}" -eq 0 ]]
then
  echo "No arguments passed in. Script exiting" 1>&2
  exit 1
fi

#
# Early exit if too many arguments are passed in
#
if [[ "${#}" -gt 2 ]]
then
  echo "Too many arguments passed in. Script exiting" 1>&2
  exit 2
fi

#
# Early exit if argument $1 is not a valid activity
#
if [[ "${1}" != "${TRAIN}" ]] && [[ "${1}" != "${WORK}" ]]
then
  echo "${1} is not a valid activity.
       Please verify where this script is being called from." 1>&2
  exit 4
fi

#
# Create the Symlink to the apropriate file
#
create_symlink_to_activity_file() {

  file="${1}"
  activity="${2}"

  echo "Setting up Maven for ${activity}"
  ln -s "/Users/${USER}/.m2/${file}" "${SETTINGS_SYMLINK}"

}

#
# Remove the symbolic link to the settings-travail.xml file
# to prevent Maven from using the corporate infrastructure from
# building artifacts.
#
setup_training_environment() {

  if [[ -f "${SETTINGS_SYMLINK}" ]]
  then
    echo "Setting up Maven for training"
    rm "${SETTINGS_WORK_SYMLINK}"
  else
    echo "This machine is already in 'Training' mode!"
  fi
}

#
# Create a symbolic link to the settings-travail.xml file
# to make Maven use the corporate infrastructure to building artifacts.
#
setup_working_environment() {
  if [[ ! -f "$SETTINGS_SYMLINK" ]]
  then
    echo "Setting up Maven for work"
    create_symlink_to_activity_file "${SETTINGS_WORK_FILE}" "work"
  else
    echo "This machine is already in 'Work' mode!"
  fi
}

#
# Receives one argument and calls the apropriate function based on its'
# value.
#
# $activity = ( work || training )
#
switch_activities() {

  activity=${1}

  if [[ "${activity}" == "${TRAIN}" ]]
  then
    setup_training_environment
  fi

  if [[ "${activity}" == "${WORK}" ]]
  then
    setup_working_environment
  fi

}

switch_activities "${1}"

#exec "${@}"

exit ${$}
