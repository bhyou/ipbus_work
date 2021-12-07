#!/usr/bin/env bash
#-------------------------------------------------------------------------------
#
#   Copyright 2017 - Rutherford Appleton Laboratory and University of Bristol
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
#                                     - - -
#
#   Additional information about ipbus-firmare and the list of ipbus-firmware
#   contacts are available at
#
#       https://ipbus.web.cern.ch/ipbus
#
#-------------------------------------------------------------------------------




SH_SOURCE=${BASH_SOURCE}
IPBUS_PATH=$(cd $(dirname ${SH_SOURCE})/../.. && pwd)
WORK_ROOT=$(cd ${IPBUS_PATH}/../.. && pwd)

PROJECTS=(sim kc705_basex kc705_gmii kcu105_basex zcu102_basex)

if (( $# != 1 )); then
  echo "No project specified."
  echo "Available projects:" $(printf "'%s' " "${PROJECTS[@]}")

  exit -1
fi
PROJ=$1
if [[ ! " ${PROJECTS[@]} " =~ " ${PROJ} " ]]; then
  # whatever you want to do when arr doesn't contain value
  echo "Project ${PROJ} not known."
  echo "Available projects: ${PROJECTS[@]}"
  exit -1
fi

# Stop on the first error
set -e
# set -x

cd ${WORK_ROOT}
rm -rf proj/${PROJ}
echo "#------------------------------------------------"
echo "Building Project ${PROJ}"
echo "#------------------------------------------------"
if [[ "$PROJ" == "sim" ]]; then
  ipbb proj create sim ${PROJ} ipbus-firmware:projects/example top_sim.dep
  cd proj/${PROJ}
  ipbb sim setup-simlib
  ipbb sim ipcores
  ipbb sim fli
  ipbb sim generate-project
  cd proj/sim
  set -x
  ./run_sim -c work.top -gIP_ADDR='X"c0a8c902"' -do 'run 60sec' -do 'quit' > /dev/null 2>&1 &
  VSIM_PID=$!
  VSIM_PGRP=$(ps -p ${VSIM_PID} -o pgrp=)
  # ait for the simulation to start
  sleep 10
  # tickle the simulation
  ping 192.168.201.2 -c 5
  # Cleanup, send SIGINT to the vsimk process in the current process group
  pkill -SIGINT -g ${VSIM_PGRP} vsimk
  set +x
else
  ipbb proj create vivado ${PROJ} ipbus-firmware:projects/example top_${PROJ}.dep
  cd proj/${PROJ}
  ipbb vivado generate-project
  ipbb vivado synth -j4
  ipbb vivado impl 
  ipbb vivado bitfile
  cd -
fi

exit 0
