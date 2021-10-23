#!/bin/bash

set -e

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" 
    exit 1
fi

script_dir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
vitis_config_dir="${script_dir}/../../windows/vitis/install_config_linux.txt"

# NOTE: will need changing
vitis_files_dir="/bulk-storage-slow/nfs/general/big_file_storage/"

work_dir="/tmp/vitis_tmp_dir"
mkdir -p ${work_dir}

cd ${work_dir}
echo "Extracting Vitis Files"
tar xvf ${vitis_files_dir}/Xilinx_Unified_2020.1_0602_1208.tar.gz
tar xvf ${vitis_files_dir}/Xilinx_Vivado_Vitis_Update_2020.1.1_0805_2247.tar.gz

cd ${work_dir}/Xilinx_Unified_2020.1_0602_1208
echo "Installing Main Vitis"
./xsetup -c ${vitis_config_dir} --agree XilinxEULA,3rdPartyEULA,WebTalkTerms --batch Add

cd ${work_dir}/Xilinx_Vivado_Vitis_Update_2020.1.1_0805_2247
echo "Updating Vitis"
./xsetup -b Update

cd /tmp
rm -rf ${work_dir}