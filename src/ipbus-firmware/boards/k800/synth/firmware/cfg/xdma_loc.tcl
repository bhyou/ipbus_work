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


# Post-upgrade XDMA core customisation
# Update the core constraints to locate the PCIe block and the surrounding logic 
# in the appropriate area of the ku115 FPGA and to the appropriate quad.
# 
# Note: Although this effectiverly changes the core constraints it is 
# a setup file, and ofr this reason is located in the cfg folder.
set_property -dict [list CONFIG.pcie_blk_locn {X0Y0} CONFIG.select_quad {GTH_Quad_225}] [get_ips xdma_0]
